--POSTGRES
-- Make DB
DROP DATABASE IF EXISTS qaa_db;
CREATE DATABASE qaa_db;
\c qaa_db

--schema create

-- products
  CREATE TABLE products (
    id SERIAL,
    name TEXT,
    slogan TEXT,
    description TEXT,
    category TEXT,
    price INT,
    PRIMARY KEY(id)
  );


-- questions
  CREATE TABLE questions (
    id SERIAL,
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


-- answers
  CREATE TABLE answers (
    id SERIAL,
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


-- photos
  CREATE TABLE photos (
    id SERIAL,
    answer_id INT,
    url TEXT,
    PRIMARY KEY(id),
    FOREIGN KEY (answer_id)
      REFERENCES answers(id)
  );


--have to do in order
COPY products(id, name, slogan, description, category, price)
FROM '/Users/marclawson/hackreactor/qaa/database/product.csv'
DELIMITER ','
CSV HEADER;

COPY questions(id, product_id, body, date_written, asker_name, asker_email, reported, helpful)
FROM '/Users/marclawson/hackreactor/qaa/database/questions.csv'
DELIMITER ','
CSV HEADER;


COPY answers(id, question_id, body, date_written, answerer_name, answerer_email, reported, helpfulness)
FROM '/Users/marclawson/hackreactor/qaa/database/answers.csv'
DELIMITER ','
CSV HEADER;


COPY photos(id, answer_id, url)
FROM '/Users/marclawson/hackreactor/qaa/database/answers_photos.csv'
DELIMITER ','
CSV HEADER;

CREATE INDEX questions_id_index on questions(product_id);
CREATE INDEX answers_id_index on answers(question_id);
CREATE INDEX photo_id_index on photos(answer_id);

                            ^
-- qaa_db=# SELECT MAX(id) FROM questions;
--    max
-- ---------
--  3518963
-- (1 row)
-- qaa_db=# SELECT nextval('questions_id_seq');
--  nextval
-- ---------
--        1
-- (1 row)
-- qaa_db=# SELECT pg_catalog.setval(pg_get_serial_sequence('questions', 'id'), (SELECT MAX(id) FROM questions)+1);
--  setval
-- ---------
--  3518964
-- (1 row)

-- qaa_db=# SELECT nextval('questions_id_seq');
--  nextval
-- ---------
--  3518965
-- (1 row)

--aws copy
-- COPY products(id, name, slogan, description, category, price)
-- FROM '/home/ubuntu/product.csv'
-- DELIMITER ','
-- CSV HEADER;

-- COPY questions(id, product_id, body, date_written, asker_name, asker_email, reported, helpful)
-- FROM '/home/ubuntu/questions.csv'
-- DELIMITER ','
-- CSV HEADER;


-- COPY answers(id, question_id, body, date_written, answerer_name, answerer_email, reported, helpfulness)
-- FROM '/home/ubuntu/answers.csv'
-- DELIMITER ','
-- CSV HEADER;


-- COPY photos(id, answer_id, url)
-- FROM '/home/ubuntu/answers_photos.csv'
-- DELIMITER ','
-- CSV HEADER;