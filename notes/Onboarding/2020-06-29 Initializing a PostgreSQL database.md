Goal:

- More familiarty with Postgres and SQL
- Initialize a Postgres database

- Spin up Stock Scoreboard app with this new database



1. In terminal create a new PostgreSql database:

   - `createdb dan_scoreboard`

2. Enter into the database:

   - `psql -d dan_scoreboard`

3. You can see a list of your databases by typing `\l` 

4. You can see of tables (or "relations") in your current database by typing `\d`. If you do this now from the `dan_scoreboard` database, it will say "Did not find any relations".

5. Create a table for S&P 500 data:

   - ```sql
     CREATE TABLE s_and_p (
     id serial UNIQUE NOT NULL,
     hist_date date NOT NULL,
     close_price numeric(9, 2) NOT NULL
     );
     ```

   - The SQL above creates a table named `s_and_p` with three columns named `id`, `hist_date` and `close_price`. 

   - The `id` column has a data type of `serial`. This data type is used to create identifier columns for a PostgreSQL database. These identifiers are integers, auto-incrementing, and cannot contain a null value.

   - The  `hist_date` column has a data type of `date` and can't be empty. The `close_price` column has a data type of `numeric`. The `numeric` data type takes two arguments, the first being the total number of digits in the entire number on both sides of the decimal point (the precision), the second is the number of the digits in the fractional part of the number to the right of the decimal point (the scale). So (9, 2) means the largest number can be: 9999999.99. (There's 9 total digits, and two of them are right of the decimal point).

6. Create a table for the user's stock data:

   - ```sql
     CREATE TABLE stocks (
         id serial UNIQUE NOT NULL,
         ticker text NOT NULL,
         shares numeric(9,3) NOT NULL,
         purchase_date date NOT NULL,
         purchase_price numeric(9,2) NOT NULL,
         commission numeric(6,2) NOT NULL,
         s_and_p_at_stock_purchase_date numeric(9,2) NOT NULL
     );
     ```

   - The SQL above creates a table named `stocks` with 7 columns. The `ticker` column has a type of `text`, which allows for variable unlimited length.  The `purchase_date` column has the type of `date` which is pretty flexible for the format order of dates. I tend to use the format yyyy-mm-dd when imputting into SQL (1999-01-08). The rest of the columns are of type numeric which I discussed above.

7. Now when you type `\d` you should see 4 items:

![Screen Shot 2020-06-29 at 10.02.43 AM](/Users/nathanworden/Desktop/Screen Shot 2020-06-29 at 10.02.43 AM.png)

		 - The two tables are the ones we just made. The two sequences are created from the `serial` data types that are keeping track of the auto-incrementing id numbers in those two tables.

8. Create a new table for the `table_sort_rule`:

   - ```sql
     CREATE TABLE table_sort_rule (
     sort_rule text
     );
     ```

   - This table just has one column called `sort_rule` with a `text` data type and its only purpose is to keep track of which column in the stock scoreboard app is the one sorting the data. I want to change how the sorting is done so that this table becomes unnecessary, but for now it is needed to make the app run.

9. Create a table for the Time Weigned Return calculation:

10. ```sql
    CREATE TABLE time_weighted_return (
        id serial unique NOT NULL,
        purchase_date date NOT NULL,
        ending_portfolio_value numeric(12,2) NOT NULL,
        cash_flow numeric(12,2) NOT NULL,
        portfolio_value_after_cash_flow numeric(12,2) NOT NULL,
        holding_period_return numeric(12,5) NOT NULL,
        time_weighted_return numeric(12,5) NOT NULL
    );
    ```

    - This table holds data that is necessary to calculate the Time Weigned Return, which is calculated differently than a normal return calculation.

11. Now that we've created all our tables, we need to put data into the table. You can put in data into the `stocks` table like this:

    - ```sql
      INSERT INTO stocks (id, ticker, shares, purchase_date, purchase_price, commission, s_and_p_at_stock_purchase_date)
      VALUES (56,	'RCL',	50.000,	'2020-03-09',	50.85,	0.00,	2746.56),
      (59,	'XOM',	41.000,	'2020-03-09',	41.79,	0.00,	2746.56),
      (58,	'F',	200.000,	'2020-03-06',	6.59,	0.00,	2972.37),
      (60,	'CCL',	100.000,	'2020-03-13',	18.35,	0.00,	2711.02),
      (61,	'EOG',	30.000,	'2020-03-10',	40.29,	0.00,	2882.23),
      (55,	'AAL',	156.000,	'2020-03-05',	16.61,	0.00,	3023.94),
      (77,	'DIS',	10.000,	'2020-03-16',	96.06,	0.00,	2386.13),
      (93,	'NLY',	250.000,	'2020-05-19',	6.30,	0.00,	2922.94),
      (96,	'WYNN',	35.000,	'2020-04-03',	47.85,	0.00,	2488.65),
      (97,	'PRU',	20.000,	'2020-06-04',	64.70,	0.00,	3112.35),
      (98,	'BA',	15.000,	'2020-06-08',	229.00,	0.00,	3219.98),
      (99,	'PRU',	50.000,	'2020-06-08',	73.00,	0.00,	3219.91),
      (100,	'RDFN',	4.000,	'2020-06-12',	32.76,	0.00,	3002.10);
      ```

12. You can put the initial sorting rule into the `table_sort_rule` table like this:

- ```sql
  INSERT INTO table_sort_rule (sort_rule)
  VALUES ('purchase_date');
  ```

13. The `s_and_p` data is a little harder because there is so much of it. Here is the data for the S&P 500 going back to the beginning of this year:

- ```sql
  INSERT INTO s_and_p (hist_date, close_price)
  VALUES ('2020-01-02',	3257.85),
  ('2020-01-03',	3234.85),
  ('2020-01-06',	3246.28),
  ('2020-01-07',	3237.18),
  ('2020-01-08',	3253.05),
  ('2020-01-09',	3274.70),
  ('2020-01-10',	3265.35),
  ('2020-01-13',	3288.13),
  ('2020-01-14',	3283.15),
  ('2020-01-15',	3289.29),
  ('2020-01-16',	3316.81),
  ('2020-01-17',	3329.62),
  ('2020-01-21',	3320.79),
  ('2020-01-22',	3321.75),
  ('2020-01-23',	3325.54),
  ('2020-01-24',	3295.47),
  ('2020-01-27',	3243.63),
  ('2020-01-28',	3276.24),
  ('2020-01-29',	3273.40),
  ('2020-01-30',	3283.66),
  ('2020-01-31',	3225.52),
  ('2020-02-03',	3248.92),
  ('2020-02-04',	3297.59),
  ('2020-02-05',	3334.69),
  ('2020-02-06',	3345.78),
  ('2020-02-07',	3327.71),
  ('2020-02-10',	3352.09),
  ('2020-02-11',	3357.75),
  ('2020-02-12',	3379.45),
  ('2020-02-13',	3373.94),
  ('2020-02-14',	3380.16),
  ('2020-02-18',	3370.29),
  ('2020-02-19',	3386.15),
  ('2020-02-20',	3373.23),
  ('2020-02-21',	3337.75),
  ('2020-02-24',	3225.89),
  ('2020-02-25',	3128.21),
  ('2020-02-26',	3116.39),
  ('2020-02-27',	2978.76),
  ('2020-02-28',	2954.22),
  ('2020-03-02',	3090.23),
  ('2020-03-03',	3003.37),
  ('2020-03-04',	3130.12),
  ('2020-03-05',	3023.94),
  ('2020-03-06',	2972.37),
  ('2020-03-09',	2746.56),
  ('2020-03-10',	2882.23),
  ('2020-03-11',	2741.38),
  ('2020-03-12',	2480.64),
  ('2020-03-13',	2711.02),
  ('2020-03-16',	2386.13),
  ('2020-03-17',	2529.19),
  ('2020-03-18',	2398.10),
  ('2020-03-19',	2409.39),
  ('2020-03-20',	2304.92),
  ('2020-03-23',	2237.40),
  ('2020-03-24',	2447.33),
  ('2020-03-25',	2475.56),
  ('2020-03-26',	2630.07),
  ('2020-03-27',	2541.47),
  ('2020-03-30',	2626.65),
  ('2020-03-31',	2584.59),
  ('2020-04-01',	2470.50),
  ('2020-04-02',	2526.90),
  ('2020-04-03',	2488.65),
  ('2020-04-06',	2663.68),
  ('2020-04-07',	2659.41),
  ('2020-04-08',	2749.98),
  ('2020-04-09',	2789.82),
  ('2020-04-13',	2761.63),
  ('2020-04-14',	2846.06),
  ('2020-04-15',	2783.36),
  ('2020-04-16',	2799.55),
  ('2020-04-17',	2874.56),
  ('2020-04-20',	2823.16),
  ('2020-04-21',	2736.56),
  ('2020-04-22',	2799.31),
  ('2020-04-23',	2797.80),
  ('2020-04-24',	2836.74),
  ('2020-04-27',	2878.48),
  ('2020-04-28',	2863.39),
  ('2020-04-29',	2939.51),
  ('2020-04-30',	2912.43),
  ('2020-05-01',	2830.71),
  ('2020-05-04',	2842.74),
  ('2020-05-05',	2868.44),
  ('2020-05-06',	2848.42),
  ('2020-05-07',	2881.19),
  ('2020-05-08',	2929.80),
  ('2020-05-09',	2881.19),
  ('2020-05-10',	2929.80),
  ('2020-05-11',	2930.32),
  ('2020-05-12',	2870.12),
  ('2020-05-13',	2820.00),
  ('2020-05-14',	2852.50),
  ('2020-05-15',	2852.50),
  ('2020-05-17',	2863.70),
  ('2020-05-18',	2953.91),
  ('2020-05-19',	2922.94),
  ('2020-05-20',	2971.61),
  ('2020-05-21',	2948.51),
  ('2020-05-22',	2948.51),
  ('2020-05-23',	2948.51),
  ('2020-05-24',	2948.51),
  ('2020-05-25',	2955.45),
  ('2020-05-26',	2991.77),
  ('2020-05-27',	3036.13),
  ('2020-05-28',	3029.73),
  ('2020-05-29',	3029.73),
  ('2020-05-30',	3029.73),
  ('2020-05-31',	3044.31),
  ('2020-06-01',	3055.73),
  ('2020-06-02',	3080.82),
  ('2020-06-03',	3122.87),
  ('2020-06-04',	3112.35),
  ('2020-06-06',	3112.35),
  ('2020-06-07',	3193.93),
  ('2020-06-08',	3232.39),
  ('2020-06-09',	3207.18),
  ('2020-06-10',	3190.14),
  ('2020-06-11',	3002.10),
  ('2020-06-12',	3002.10),
  ('2020-06-14',	3041.31),
  ('2020-06-15',	3066.59),
  ('2020-06-16',	3124.74),
  ('2020-06-17',	3113.49),
  ('2020-06-18',	3115.34),
  ('2020-06-20',	3115.34),
  ('2020-06-21',	3097.74),
  ('2020-06-22',	3117.86),
  ('2020-06-23',	3131.29),
  ('2020-06-24',	3050.33),
  ('2020-06-25',	3083.76),
  ('2020-06-26',	3083.76),
  ('2020-06-27',	3083.76),
  ('2020-06-28',	3009.05);
  ```

  14. Insert data into the `time_weighted_return` table:

  ```sql
  INSERT INTO time_weighted_return (id, purchase_date, ending_portfolio_value, cash_flow, portfolio_value_after_cash_flow, holding_period_return, time_weighted_return)
  VALUES (1,	'2020-03-05',	2591.16,	0.00,	2591.16,	0.00000,	0.00000),
  (2,	'2020-03-06',	2491.32,	1318.00,	3809.32,	-3.85310,	-3.85310),
  (4,	'2020-03-10',	8267.31,	1208.70,	9476.01,	12.41525,	-1.23181),
  (5,	'2020-03-13',	7581.78,	1835.00,	9416.78,	-19.98974,	-20.97532),
  (6,	'2020-03-16',	8786.61,	960.00,	9747.21,	-6.69199,	-26.26364),
  (7,	'2020-04-03',	8124.45,	1674.75,	9799.20,	-16.64846,	-38.53961),
  (3,	'2020-03-09',	3481.00,	3873.26,	7354.26,	-8.61886,	-12.13987),
  (8,	'2020-05-19',	13167.43,	1575.00,	14742.43,	34.37250,	-17.41413);
  ```

  

  14. now when you type `\d` into terminal you should get something like this:
  15. And you can see what is in the tables by typing `table stocks` or `table s_and_p`. (For the s_and_p table, since there is a lot of data, you might have to hit `q` to jump out of it).

16. Ok, we have now set everything we need to up in the PostgreSQL database. Now we just need to tell the app to use the right database. 
    - In the root folder of the app, open up `database_persistence.rb` and change line 10 to read: `PG.connect(dbname: "dan_scoreboard")`.
17. Spin up the app: 
    - In terminal run `bundle_exec ruby stock_scoreboard.rb` And you should see the data in the table populated.

