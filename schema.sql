--POSTGRES
-- Make DB
DROP DATABASE IF EXISTS qaa_db;
CREATE DATABASE qaa_db;
\c qaa_db

--schema create
-- DROP SCHEMA IF EXISTS qaa;
-- CREATE SCHEMA qaa;

-- products
  CREATE TABLE products (
    id INT,
    name TEXT,
    slogan TEXT,
    description TEXT,
    category TEXT,
    price INT,
    PRIMARY KEY(id)
  );
  --ALTER TABLE products ADD CONSTRAINT products_pkey PRIMARY KEY (id);

-- questions
  CREATE TABLE questions (
    id INT,
    product_id INT,
    body TEXT,
    date_written BIGINT,
    asker_name TEXT,
    asker_email TEXT,
    reported BOOLEAN,
    helpful INT,
    PRIMARY KEY(id),
    FOREIGN KEY(product_id)
      REFERENCES products(id)
  );
  --ALTER TABLE questions ADD CONSTRAINT questions_pkey PRIMARY KEY(id);

-- answers
  CREATE TABLE answers (
    id INT,
    question_id INT,
    body TEXT,
    date_written BIGINT,
    answerer_name TEXT,
    answerer_email TEXT,
    reported BOOLEAN,
    helpfulness INT,
    PRIMARY KEY (id),
    FOREIGN KEY (question_id)
      REFERENCES questions(id)
  );
  --SELECT to_timestamp(date_written);
  --ALTER TABLE answers ADD CONSTRAINT answers_pkey PRIMARY KEY (id);

-- photos
  CREATE TABLE photos (
    id INT,
    answer_id INT,
    url TEXT,
    PRIMARY KEY(id),
    FOREIGN KEY (answer_id)
      REFERENCES answers(id)
  );
  --ALTER TABLE photos ADD CONSTRAINT photos_pkey PRIMARY KEY (id);

-- foreign keys


  -- {
  --   "product_id": "44388",
  --   "results": [
  --       {
  --           "question_id": 543166,
  --           "question_body": "Is this a center for ants?!",
  --           "question_date": "2021-11-06T00:00:00.000Z",
  --           "asker_name": "Derek Z.",
  --           "question_helpfulness": 1070,
  --           "reported": false,
  --           "answers": {
  --               "5087574": {
  --                   "id": 5087574,
  --                   "body": "No, it's a center for kids that can't read good.",
  --                   "date": "2021-11-06T00:00:00.000Z",
  --                   "answerer_name": "Mugatu",
  --                   "helpfulness": 54,
  --                   "photos": []
  --                 },
  --               ......
  --             }
  --       }
  --       .....
  -- }

--   COPY persons(first_name, last_name, dob, email)
-- FROM 'C:\sampledb\persons.csv'
-- DELIMITER ','
-- CSV HEADER;