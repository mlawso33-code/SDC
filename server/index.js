const express = require('express');
const axios = require('axios');
const pool = require('./db.js');
const app = express();

//connecting app to server
const PORT = 3000;

//middleware
app.use(express.json());


//routes

//questions
app.get('/qa/questions', (req, res) => {
  let { product_id, page = 1, count = 5 } = req.query
  const questionQuery = `SELECT jsonb_build_object(
    'product_id', questions.product_id,
    'results', jsonb_agg(jsonb_build_object(
      'question_id', questions.id,
      'question_body', questions.body,
      'question_date', (SELECT to_timestamp(questions.date_written)),
      'asker_name', questions.asker_name,
      'asker_email', questions.asker_email,
      'reported', questions.reported,
      'helpful', questions.helpful,
      'answers', (SELECT jsonb_object_agg(
        answers.id, (SELECT json_build_object(
          'id', answers.id,
          'body', answers.body,
          'date', (SELECT to_timestamp(answers.date_written)),
          'answerer_name', answers.answerer_name,
          'reported', answers.reported,
          'helpfulness', answers.helpfulness,
          'photos', (SELECT jsonb_agg(json_build_object(
            'id', photos.id,
            'url', photos.url
          )) FROM photos WHERE answer_id=answers.id)
        )
        )
      ) FROM answers WHERE question_id=questions.id)
    ))
  ) FROM (
      SELECT id, product_id, body, date_written, asker_name, asker_email, reported, helpful
      FROM questions) AS questions LEFT JOIN products r on questions.product_id = r.id
  WHERE r.id=${product_id}
  GROUP BY questions.product_id;`

  pool.query(questionQuery, [], (err, result) => {
    err ? console.log(err) : res.send(result.rows[0].jsonb_build_object);
  })
});

app.post('/qa/questions', (req, res) => {
  let { body, name, email, product_id } = req.body
  const addQuestions = `INSERT INTO questions(body, asker_name, asker_email, product_id) VALUES ('${body}', '${name}', '${email}', ${product_id});`
  pool.query(addQuestions, [], (err, result) => {
    err ? console.log(err) : res.send(201)
  })
});

//questions helpful
app.put('/qa/questions/:question_id/helpful', (req, res) => {
  let { question_id } = req.params
  const updateQHelpful = `UPDATE questions SET helpful = helpful+1 WHERE id=${question_id}`
  pool.query(updateQHelpful, [], (err, result) => {
    err ? console.log(err) : res.sendStatus(204)
  })
})
//questions report
app.put('/qa/questions/:question_id/report', (req, res) => {
  let { question_id } = req.params
  const updateQReport = `UPDATE questions SET reported = NOT reported WHERE id=${question_id}`
  pool.query(updateQReport, [], (err, result) => {
    err ? console.log(err) : res.sendStatus(204)
  })
})

//answers
app.get('/qa/questions/:question_id/answers', (req, res) => {
  let { question_id, page = 1, count = 5 } = req.params
  const answerQuery = `SELECT jsonb_build_object(
  'question', ${question_id},
  'page', ${page},
  'count', ${count},
    'results', (SELECT jsonb_object_agg(
      answers.id, (SELECT json_build_object(
        'id', answers.id,
        'body', answers.body,
        'date', (SELECT to_timestamp(answers.date_written)),
        'answerer_name', answers.answerer_name,
        'reported', answers.reported,
        'helpfulness', answers.helpfulness,
        'photos', (SELECT jsonb_agg(json_build_object(
          'id', photos.id,
          'url', photos.url
        )) FROM photos WHERE answer_id=answers.id)
      )
      )
    ) FROM answers WHERE question_id=${question_id}));`

  pool.query(answerQuery, [], (err, result) => {
    err ? console.log(err) : res.send(result.rows[0].jsonb_build_object)
  })
});

app.post('/qa/questions/:question_id/answers', (req, res) => {
  let { question_id } = req.params
  let { body, name, email, photos } = req.body
  const addQuestions = `INSERT INTO answers(body, answerer_name, answerer_email)
    VALUES ('${body}', '${name}', '${email}') RETURNING *;`
    //promise chain, then = will continue to work until there is an err, until catch = err
  pool.query(addQuestions).then(
    ({ rows }) => {
      let valueArr = [];
      let value;
      for (var i = 0; i < photos.length; i++) {
        value = `('${photos[i]}')`
        valueArr.push(value)
      }
      valueArr = valueArr.join(", ");
      const addPhotos = `INSERT INTO photos(answer_id, url) VALUES (${rows[0].id}, ${value});`
      pool.query(addPhotos, [], (err, result) => {
        //instead of using callback"(err, result)", you can do an original if/else = query
        //headers are by send
        err ? console.log(err) : res.sendStatus(201)
      })
    }
  ).catch(err => { console.log(err) })
});

app.put('/qa/answers/:answer_id/helpful', (req, res) => {
  let { answer_id } = req.params
  const updateAHelpful = `UPDATE answers SET helpfulness = helpfulness+1 WHERE id=${answer_id}`
  pool.query(updateAHelpful, [], (err, result) => {
    err ? console.log(err) : res.sendStatus(204)
  })
})
app.put('/qa/answers/:answer_id/report', (req, res) => {
  let { answer_id } = req.params
  const updateAHelpful = `UPDATE answers SET reported = NOT reported WHERE id=${answer_id}`
  pool.query(updateAHelpful, [], (err, result) => {
    err ? console.log(err) : res.sendStatus(204)
  })
})


app.listen(PORT, () => { console.log(`Listening on port: ${PORT}`) })


//console logs for body, query, params
//console.log('body:::', req.body)
//console.log('query:::', req.query)
//console.log('params:::', req.params)