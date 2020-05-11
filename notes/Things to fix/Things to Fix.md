## Stock Scorecard things to fix





#### 5/10/20

- **On Heroku, after adding the `<script>` which allowed the print page functionality, the action button in the stock table only works for the last one in the table and not any others. They all still work on the localhost version, but not the heroku version.**

- On the "Add a Position" If you enter the 'purchase price' with a dollar sign ($), it gives you this error: ` invalid input syntax for type numeric: "$30.28"`

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



### 5/6/20

When you Add a position, if you leave the 'Commission' Field blank, it gives you an 'Internal Server Error' - fixed 5/9/20

Fixed by adding `@all_params["commission"] = 0 if @all_params["commission"] == ""` to `post "/addposition" do` route.

### 4/29/20

- **How to deal with reverse stock splits. (Example in screen shot with USO. Did an 8:1 reverse split on 4/29/20)**

- **How to deal with normal stock splits**