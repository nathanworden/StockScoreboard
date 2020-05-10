DATABASE UPDATE LOG

#### 5/10/20

On the 'Add a Position' page, if you entered a fractional share (aka, typed in 20.5 or some other decimal number into the shares input field) you would get an error that said 'invalid input syntax for type integer: "20.5". It listed the file as `database_persistence.rb`. 

What I think was happening:

The schema for the stocks table looks like this:

```sql
CREATE TABLE stocks (
id serial UNIQUE NOT NULL,
ticker text NOT NULL,
shares integer NOT NULL,
purchase_date date NOT NULL,
purchase_price decimal(9, 2) NOT NULL,
commission decimal (6, 2) NOT NULL,
s_and_p_at_stock_purchase_date numeric(9, 2)
);
```

Specifically, the shares column has a data type of integer. To have fractional shares this needs to be a float. Or in SQL parlance, 'numeric' or 'decimal'. So the fix is this:

Enter your psql console: ` psql -d stock_scoreboard` (or if you are logging into Heroku: `heroku pg:psql -a stock-scoreboard`)

Alter the stocks table and shares column: `ALTER TABLE stocks ALTER COLUMN shares TYPE numeric(9,3);`

Now when you go back and Add a Position you can do fractional shares.

#### 5/9/20



**4/21/20**

Wanted to check what the S&P500 was on the day a stock was bought. But my iMac didn't have heroku installed yet.

`brew tap heroku/brew && brew install heroku`

`heroku login`

You’ll be prompted to enter any key to go to your web browser to complete login. The CLI will then log you in automatically.

Then to connect to my app's PostgreSQL database:

`heroku pg:psql -a stock-scoreboard`



##### 4/17/20

Old MacBook was breaking down, so I needed to export the database. Followed instructions from postgresql.org:

https://www.postgresql.org/docs/9.1/backup-dump.html

`pg_dump dbname > outfile`

In my case this was:

 `pg_dump stock_scorecard > stock_scoreboard_dump.sql`

Then emailed `stock_scoreboard_dump.sql` to myself. Downloaded it on my iMac. Then created the database on my iMac:

In terminal: `createdb stock_scoreboard` 

I changed the name from `stock_scorecard` to `stock_scoreboard` so I needed to update `database_persistence.rb` so that the `PG.connect(dbname: "stock_scoreboard")` was correct.

Then I imported the database dump:

`psql stock_scoreboard < stock_scoreboard_dump.sql`

Then renamed the file and saved it in a folder called 'database dumps'. New name is `04172020_stock_scoreboard_dump.sql`

Was able to run `bundle exec ruby stockscoreboard.rb` and got everything to run correctly.



##### 4/10/20

- Added a `NOT NULL` clause to the `s_and_p_at_stock_purchase_date` column in the `stocks` table:

`ALTER TABLE stocks ALTER COLUMN s_and_p_at_stock_purchase_date SET NOT NULL;`

- The changes to code were updated to Heroku using `git push heroku master` but this didn't update the data *in* the database on Heroku. So you need to go update that data spicifically. To set up database schema (or insert data) manually, you can log into a psql shell on Heroku with:

`heroku pg:psql -a stock-scoreboard`

By taking a look at the table: `table stocks` you can see that currently the column `s_and_p_at_stock_purchase_date` doesn't exist yet. This is presumably why in the app the "vs. S&P" column is reading "-Infinity%" for every row.

##### 4/9/2020

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



