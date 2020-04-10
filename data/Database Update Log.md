DATABASE UPDATE LOG



4/9/2020

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

