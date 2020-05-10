## UPDATE LOG

#### 5/10/20

- Bug Fix: On the 'Add a Position' page, if you entered a fractional share (aka, typed in 20.5 or some other decimal number into the shares input field) you would get an error that said 'invalid input syntax for type integer: "20.5". It listed the file as `database_persistence.rb`. 

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

​	Specifically, the shares column has a data type of integer. To have fractional shares this 		needs to be a float. Or in SQL parlance, 'numeric' or 'decimal'. So the fix is this:

​	Enter your psql console: ` psql -d stock_scoreboard` (or if you are logging into Heroku: 	`heroku pg:psql -a stock-scoreboard`)

​	Alter the stocks table and shares column: `ALTER TABLE stocks ALTER COLUMN shares TYPE numeric(9,3);`

​	Now when you go back and Add a Position you can do fractional shares.

- Added Functionality so the print button actually opens the 'print page' dialogue screen! In the `layout.erb` file in the `section` with class `table-toolbar`, in the `<button>` inside of the `<g class="print">` add this to the button:

  - `<button onclick="display()">`

  - Then, down at the bottom of the page add a new `scrip` after `</main>` with the following:

    - <script>
            function display() {window.print()}
      </script>

- The `s_and_p` table had duplicate data for the S&P 500 for April 7th and April 8th. And then after that it had missing data for a lot of days in April when I didn't open up StockScoreboard. (The `todays_sp_points` scraper only occurs when you open the app to run the code ). 
  - Fix: Manually input S&P 500 close prices from 4/8/20 to today (5/10/20).
    - `UPDATE s_and_p SET close_price = 2749.98 WHERE hist_date = '2020-04-08';`
  - If you just start adding the info, it gets tacked onto the end of the table and not ordered by date. You could use `ORDER BY` in your SQL query to order it by the `hist_date` but to be safe I'm going to delete all data back to where the error started occuring and input the correct data in the right order from there:
    - `DELETE FROM s_and_p WHERE hist_date > '2020-04-08';`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-09', 2789.82);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-13', 2761.63);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-14', 2846.06);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-15', 2783.36);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-16', 2799.55);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-17', 2874.56);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-20', 2823.16);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-21', 2736.56);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-22', 2799.31);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-23', 2797.80);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-24', 2836.74);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-27', 2878.48);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-28', 2863.39);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-29', 2939.51);`
    - ` INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-04-30', 2912.43);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-05-01', 2830.71);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-05-04', 2842.74);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-05-05', 2868.44);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-05-06', 2848.42);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-05-07', 2881.19);`
    - `INSERT INTO s_and_p (hist_date, close_price) VALUES ('2020-05-08', 2929.80);`
- The `s_and_p` table on heroku only had data from April and May. To pull in data from all the way back to 1900, I did the following:
  - Database dump of all Schema of `stock_scoreboard` :
    - `pg_dump stock_scoreboard > 05102020_stock_scoreboard_dump.sql`
    - In this file all the lines from the table `s_and_p` exiscted, so I copied all of those.
    - Log into Postgres on heroku: `heroku pg:psql -a stock-scoreboard`
    - I cleared out all the current data in the table (not sure if this is necessary): `DELETE FROM s_and_p WHERE id > 0;` 
    - Tell Postgres you are copying data `COPY public.s_and_p (hist_date, close_price) FROM stdin;`
    - Then heroku (or Postgres?) responds back saying: "Enter data to be copied followed by a newline. End with a backslash and a period on a line by itself, or an EOF signal."
    - That's when I pasted all the lines of S&P500 data all the way back to 1900 (from the second bullet point above) and then hit 'enter' for the newline and then a `\.` to signal I was done.
    - It gave me "`COPY 32549`", and all of that data appears to be in there now!

#### 5/9/20

- Added a 'Total Return' metric to the main homescreen. It is just the total return amount to date (positive or negative) divided by the total cost basis for the whole portfolio.

- Added the ability to have the negative sign be before the dollar sign in the  `format_num(num, include_dollar_sign)` function in `stockcoreboard.rb` . Also added the ability to tell it whether to include the dollar sig or not. (Because the dollar sign is not needed for metrics such as shares or the point value of 'Today's S&P 500').

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

- As of now When you add a stock position, the app will web scrape the current S&P500 point value as of the time you enter the position. (It uses `todays_sp_points` in `scrape_todays_s_and_p.rb`)


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



