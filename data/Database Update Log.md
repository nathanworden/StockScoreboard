DATABASE UPDATE LOG

`NOT NULL`

##### 4/10/20

- Added a `NOT NULL` clause to the `s_and_p_at_stock_purchase_date` column in the `stocks` table:

`ALTER TABLE stocks ALTER COLUMN s_and_p_at_stock_purchase_date SET NOT NULL;`

- The changes to code were updated to Heroku using `git push heroku master` but this didn't update the data *in* the database on Heroku. So you need to go update that data spicifically. To set up database schema (or insert data) manually, you can log into a psql shell on Heroku with:

`heroku pg:psql -a stock-scoreboard`

By taking a look at the table: `table stocks` you can see that currently the column `s_and_p_at_stock_purchase_date` doesn't exist yet. This is presumably why in the app the "vs. S&P" column is reading "-Infinity%" for every row.

#####4/9/2020

- Added a new column to the `stocks` table for the S&P 500 price at the time of the stock's purchase:

`ALTER TABLE stocks ADD COLUMN s_and_p_at_stock_purchase_date numeric(9, 2);`

- Populated the column for the stocks that were currently in the table by looking up the S&P price manually on the date the stock was purchased. Used the following commands:

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 2746.56 WHERE purchase_date = '2020-03-09';`

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 2386.13 WHERE purchase_date = '2020-03-16';`

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 2972.37 WHERE purchase_date = '2020-03-06';`

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 2711.02 WHERE purchase_date = '2020-03-13';`

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 2882.23 WHERE purchase_date = '2020-03-10';`

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 2304.92 WHERE purchase_date = '2020-03-20';`

`UPDATE stocks SET s_and_p_at_stock_purchase_date = 3023.94 WHERE purchase_date = '2020-03-05';`



