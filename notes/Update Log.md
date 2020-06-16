## UPDATE LOG

### 6/17/20

Importing and Exporing Heroku PostGres Databases:

https://devcenter.heroku.com/articles/heroku-postgres-import-export

o export the data from your Heroku Postgres database, create a new backup and download it:

`heroku pg:backups:capture -a stock-scoreboard`

`heroku pg:backups:download -a stock-scoreboard`

This created a file called `latest.dump` and was just a bunch of numbers. I think it is the compresed version. Didn't actually figure out how to make a database dump like pg_dump. But keep exploring the above link.

#### 5/29/20

- Created the `time_weighted_return` table on the heroku app

  - `heroku pg:psql -a stock-scoreboard`

  ```sql
  CREATE TABLE time_weighted_return (
  id serial UNIQUE NOT NULL,
  purchase_date date NOT NULL,
  ending_portfolio_value decimal(12, 2) NOT NULL,
  cash_flow decimal(12, 2) NOT NULL,
  portfolio_value_after_cash_flow decimal(12, 2) NOT NULL,
  holding_period_return decimal(12, 5) NOT NULL,
  time_weighted_return decimal(12, 5) NOT NULL
  );
  ```

  - Example of adding data to the time_weighted_return table:

  ```sql
  INSERT INTO time_weighted_return (id, purchase_date, ending_portfolio_value, cash_flow, portfolio_value_after_cash_flow, holding_period_return, time_weighted_return) VALUES 
  (1, '2020-03-20', 1068.00, 0, 1068.00, 0, 0);
  (2, '2020-04-20', 1227.12, 1023.66, 2250.78, 14.89888, 14.89888), 
  (3, '2020-04-21', 2208.05, 2050.14, 4258.19, -1.89845, 12.71758),
  (4, '2020-04-28', 4469.37, 1047.37, 5516.74, 4.95938, 18.30767),
  (5, '2020-05-01', 5735.89, 3443.79, 9179.59, 3.97082, 23.00546),
  (6, '2020-05-21', 11544.57, 1032.58, 12577.15, 25.76346, 54.69592),
  (7, '2020-05-26', 12608.65, 959.90, 13568.55, 0.25045, 55.08337),
  (8, '2020-05-27', 13452.01, 714.30, 14166.31, -0.85890, 53.75136);
  ```

#### 5/24/20

- Check out the logo capability: `amzn = StockQuote::Stock.logo('estc')`

#### 5/23/20

- Created new PostgreSQL table for Time Weighted Returns

#### 5/11/20

- Turned all ticker input into uppercase by adding`@all_params['ticker'] = @all_params['ticker'].upcase` to the `post "/addposition"` route.
- Bug: When you enter a new position with today as the buy date, the 'vs. S&P' column says '-Infinity%'. In the stock table the `s_and_p_at_stock_purchase_date ` is being input as 0.
  - Problem ended up being: The check for ` if @all_params["purchase-date"] == Date.today` in `post "/addposition"`wasn't working because the `@all_params["purchase-date"]` was formatted differently than the `Date.today` object. 
  - Fix: When comparing the dates, format them so they are the same: `  if Date.strptime(@all_params["purchase-date"], '%m/%d/%Y') == Date.today`
- Added a session error to pop up if the date is entered incorrectly.
- Bug: When you delete a position- all other positions with the same ticker get deleted too. Want to delete based on an id instead of a ticker.
  - Fix: Was deleting based on ticker, changed references in `database_persistence.rb`, `stock_table.erb`, and `stockscoreboard.rb` (in the `post/delete-position/:ticker` route) to be `:id` instead of `:ticker`.
- Added '1 Day Change ($)' and '1 Day Change (%)' for the full portfolio metrics. This was accomplished by adding `stock[:previous_close] = stock[:current_data].previous_close` to the `pull_market_data` method and adding up the previous day's portfolio's closing market value stock by stock with `@previous_day_portfolio_market_value += stock[:previous_close] * stock[:shares]`

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

- On the "Add a Position" page If you enter the 'purchase price' with a dollar sign ($), it gives you this error: ` invalid input syntax for type numeric: "$30.28"`

  - Fixed:   Fixed by substituting out all non-digits for an empty string: `@all_params["purchase-price"] = @all_params["purchase-price"].gsub(/[^\d\.]/, '')`

- When adding a position in the past, the data being added to the `stocks` table in the `s_and_p_at_stock_purchase_date` is the web-scrapped amount of the current S&P500 instead of the historcial price. Examped: Added position "TWOU" with a buy date of '4/20/2020' at $30.28 and the "Return %" and "vs. S&P" columns read 0%.

  - Fix: Added an `if` statement to  the `post "/addposition" do` route which checked if the current date was today. If the date is today, then we can web-scrape the current S&P500 value. If the date is in the past, then we have to query the database  and get what level it was at on that date. because

  - ```ruby
      if @all_params["purchase-date"] == Date.today
        s_and_p_at_stock_purchase_date = todays_sp_points
      else
        s_and_p_at_stock_purchase_date = @storage.get_sandp_on(@all_params["purchase-date"])
      end
    ```

  - Had to update the name of the variable at the end of this line to `s_and_p_at_stock_purchase_date` because before this was where  `todays_sp_points`  was web scraping: `@storage.add_position(params["ticker"], params["shares"], params["purchase-date"], params["purchase-price"], params["commission"], s_and_p_at_stock_purchase_date)`

  - Also needed to add the following to `database_persistence.rb`:

  - ```ruby
     def get_sandp_on(date)
        sql = "SELECT close_price from s_and_p WHERE hist_date = $1"
        result = query(sql, date)
      
        result.map do |tuple|
          tuple["close_price"]
        end[0].to_f
      end
    ```

- The action button in the stock table wasn't working for stocks that had two entries in the table. (Clicking it resulted in nothing happening). Stocks with single entries would successfully have the 'delete' and 'edit' options drop dopw. 
  
  - Fix:  The `actionDropdown()` function was being fed a `ticker` instead of an `id`. Since there are multiple stock entries with the same ticker, this wasn't uniqly identifying an element and thus returned `undefined`. In `stock_table.erb` I changed the `id` of the div with the class of `dropdown-content` to `"<%= stock[:id] %>"` (instead of `<%= stock[:ticker] %>"` And similarly changed the button with the class `dropbtn` to have it's `onlick` property be `"actionDropdown(<%= stock[:id]%>)"` (instead of `"actionDropdown(<%= stock[:ticker]%>)"`)

#### 5/9/20

- Added a 'Total Return' metric to the main homescreen. It is just the total return amount to date (positive or negative) divided by the total cost basis for the whole portfolio.
- Added the ability to have the negative sign be before the dollar sign in the  `format_num(num, include_dollar_sign)` function in `stockcoreboard.rb` . Also added the ability to tell it whether to include the dollar sig or not. (Because the dollar sign is not needed for metrics such as shares or the point value of 'Today's S&P 500').

#### 5/6/20

When you Add a position, if you leave the 'Commission' Field blank, it gives you an 'Internal Server Error' - fixed 5/9/20

Fixed by adding `@all_params["commission"] = 0 if @all_params["commission"] == ""` to `post "/addposition" do` route.

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



