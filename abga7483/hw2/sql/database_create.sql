CREATE DATABASE animals_database;
USE animals_database;
CREATE TABLE Animals (
  animal_id INT NOT NULL,
  animal_name VARCHAR(20) NOT NULL,
  PRIMARY KEY (animal_id),
  UNIQUE (animal_name)
);

INSERT INTO Animals
    (animal_id, animal_name) 
VALUES 
    (1,"Lion"),
    (2,"Tiger"),
    (3,"Elephant");