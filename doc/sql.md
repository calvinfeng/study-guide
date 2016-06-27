# Basic SQL Syntax

## Data Definition Language (DDL)
Creating table
``` SQL
CREATE TABLE person (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  gender CHAR(1),
  birth_date DATE
);
```
Inserting into table
``` SQL
INSERT INTO
  person (first_name, last_name, gender, birth_date)

VALUES
  ("Calvin", "Feng", 'M', '1991-12-23'),
  ("Steven", "Jern", "M", '1985-01-01');
```

## Data Manipulation Language (DML)
Query using `SELECT`
``` SQL
SELECT *
FROM person
WHERE first_name = "Calvin" AND birth_date > '1990-01-01'
```

`BETWEEN` operator
``` SQL
SELECT id, first_name, last_name, start_date
FROM employee
WHERE start_date BETWEEN '2005-01-01' AND '2007-01-01';
```
Using sub-queries
``` SQL
SELECT id, product_cd, customer_id, avail_balance
FROM account
WHERE product_cd IN (
  SELECT product_cd
  FROM product
  WHERE product_type_cd = 'ACCOUNT'
);
```
Join tables
``` SQL
SELECT a.account_id, c.fed_id, e.first_name, e.last_name
FROM employee e INNER JOIN account a
  ON e.emp_id = a.open_emp_id
  INNER JOIN customer c
    ON a.cust_id = c.cust_id
WHERE c.cust_type_cd = 'B';
```
Self join
``` SQL
SELECT e.first_name, e.last_name, e_manager.first_name, e_manager.last_name
FROM employee e INNER JOIN employee e_manager
  ON e.superior_emp_id = e_manager.emp_id
```




## Web App Database
Heroku uses PostgreSQL and we can find PostgreSQL connection url in the terminal by typing
```
heroku pg:credentials DATABASE
```
Heroku uses Amazon AWS to host thier PostgreSQL server.

For example
![heroku-pg][heroku-pg]
[heroku-pg]: ../img/heroku-postgre.png

Rails uses pg gem for localhost and the database directory can be found in
here:
```
$ cd /usr/local/var/postgres
```

### Basic Commands in Heroku
#### Upload git to Heroku
```
git push heroku master
```
#### Reset database
```
heroku pg:reset DATABASE
heroku run rake db:migrate
heroku run rake db:seed
```

### Set up and Running
```
npm install webpack --save
npm install react --save
npm install react-dom --save
npm install flux --save
npm install babel-core --save
npm install babel-loader --save
npm install babel-preset-react --save
npm install react-router --save
```
