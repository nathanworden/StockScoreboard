## Stock Scorecard things to fix

#### 5/10/20

On Heroku, after adding the `<script>` which allowed the print page functionality, the action button in the stock table oble works for the last one in the table and not any others. They all still work on the localhost version, but not the heroku version.

### 5/6/20

When you Add a position, if you leave the 'Commission' Field blank, it gives you an 'Internal Server Error' - fixed 5/9/20

Fixed by adding `@all_params["commission"] = 0 if @all_params["commission"] == ""` to `post "/addposition" do` route.

### 4/29/20

- How to deal with reverse stock splits. (Example in screen shot with USO. Did an 8:1 reverse split on 4/29/20)

- How to deal with normal stock splits