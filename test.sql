SELECT json_build_object(
  'product_id', q.product_id,
  'results', jsonb_agg(jsonb_build_object(
    'question_id', (SELECT id FROM questions WHERE product_id=44388),
    'question_body', (SELECT body FROM questions WHERE product_id=44388),
    'question_date', (SELECT date_written FROM questions WHERE product_id=44388),
    'asker_name', (SELECT asker_name FROM questions WHERE product_id=44388),
    'asker_email', (SELECT asker_email FROM questions WHERE product_id=44388),
    'reported', (SELECT reported FROM questions WHERE product_id=44388),
    'helpful', (SELECT helpful FROM questions WHERE product_id=44388)
    ))
    ) FROM (
        SELECT product_id, body, date_written, asker_name, asker_email, reported, helpful
        FROM questions) AS q LEFT JOIN products r on q.product_id = r.id
    WHERE r.id=44388;

--current table: questions
    SELECT product_id, body, date_written, asker_name, asker_email, reported, helpful FROM questions q LEFT JOIN products r on q.product_id = r.id
    WHERE r.id=44388;


  -- SELECT json_build_object(
  -- --'product_id', q.product_id,
  -- 'results', array_agg(json_build_object(
  --   'question_id', (SELECT id FROM questions WHERE product_id=44388),
  --   'question_body', (SELECT body FROM questions WHERE product_id=44388),
  --   'question_date', (SELECT date_written FROM questions WHERE product_id=44388),
  --   'asker_name', (SELECT asker_name FROM questions WHERE product_id=44388),
  --   'asker_email', (SELECT asker_email FROM questions WHERE product_id=44388),
  --   'reported', (SELECT reported FROM questions WHERE product_id=44388),
  --   'helpful', (SELECT helpful FROM questions WHERE product_id=44388)
  --   ))
  --   ) FROM (
  --       SELECT product_id, body, date_written, asker_name, asker_email, reported, helpful
  --       FROM questions) AS q LEFT JOIN products r on q.product_id = r.id
  --   WHERE r.id=44388;


  SELECT json_build_object(
  'product_id', q.product_id,
  'results', jsonb_agg(jsonb_build_object(
    'question_id', (SELECT id FROM questions WHERE product_id=44388),
    'question_body', (SELECT body FROM questions WHERE product_id=44388),
    'question_date', (SELECT date_written FROM questions WHERE product_id=44388),
    'asker_name', (SELECT asker_name FROM questions WHERE product_id=44388),
    'asker_email', (SELECT asker_email FROM questions WHERE product_id=44388),
    'reported', (SELECT reported FROM questions WHERE product_id=44388),
    'helpful', (SELECT helpful FROM questions WHERE product_id=44388)
    )) AS questions_in_list
    ) FROM (
        SELECT product_id, body, date_written, asker_name, asker_email, reported, helpful
        FROM questions) AS q LEFT JOIN products r on q.product_id = r.id
    WHERE r.id=44388;

-- working questions list
    SELECT jsonb_build_object(
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
    WHERE r.id=44388
    GROUP BY questions.product_id;

-- working answers list
SELECT jsonb_build_object(
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
    ) FROM answers WHERE question_id=${question_id}));







-- NOTES

--     select
--     d.name as division_name
--     jsonb_agg(jsonb_build_object('name', t.name)) as teams_in_division
-- from team_season_division tsd
-- inner join teams t on t.id = tsd.team_id
-- inner join divisions d on d.id = tsd.division_id
-- where tsd.season_id = 1
-- group by d.division_id, d.name;

-- Multicolumn Indexes
-- A multicolumn index is defined on more than one column of a table. The basic syntax is as follows −

-- CREATE INDEX index_name
-- ON table_name (column1_name, column2_name);

-- Unique Indexes
-- Unique indexes are used not only for performance, but also for data integrity. A unique index does not allow any duplicate values to be inserted into the table. The basic syntax is as follows −

-- CREATE UNIQUE INDEX index_name
-- on table_name (column_name);