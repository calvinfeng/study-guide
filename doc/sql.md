# Basic SQL Syntax

## Data Manipulation Language (DML)

## Data Definition Language (DDL)





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
