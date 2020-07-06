# 2020-07-06 Onboarding



Here are some instructions on how to get started contributing to Stock Scoreboard:

1. Go to the Stock Scoreboard repository: https://github.com/nathanworden/StockScoreboard
2. Click the little 'fork' button in the top right. The new fork will then be on your repositories at [github.com/[your_user_name\]/[repo_name]](http://github.com/[your_user_name]/[repo_name]).
3. Clone the repo down to your computer: click the 'clone' button from your repo fork on GitHub, copy the SSH or https endpoint then move over to your terminal and run `git clone [your pasted endpoint from GitHub]`
4.  `cd` into the directory.
5. Create a new database locally: `createdb stock_scoreboard`
6. `cd` into this folder: `data/datbase dumps/heroku dumps/`. You should see a file called `06292020_heroku_stock_scoreboard.dump`. This is seed data in binary form that we are going to seed your local stock_scoreboard database with.
7. In terminal run: `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb 06292020_heroku_stock_scoreboard.dump` Where `myuser` is your user on your computer and `mydb` is `stock_scoreboard`
8. Back out in the root folder run `bundle install` . Then `bundle exec ruby stockscoreboard` and it should spin up on localhost:4567 for you to check out. You might have problems with Ruby versioning though. Let me know if you do.
9. If you make any changes:
10.  `git commit` your changes, then `git push origin master` to push your changes to GitHub to make your fork on GitHub contain the changes you intend to contribute.
11. Got to https://github.com/nathanworden/StockScoreboard/pulls and click 'new pull request', then 'compare across forks', then on the right side select your username from the drop down.
12. Click the 'create pull request' button and then I'll be able to see your changes and we can talk about the code!

---



Right now my most frustrating problem is how long the page takes to load. It can easily take 8-16 seconds on every refresh, which is annoyingly long. I was thinking that was because of the time it takes to get the data from the gem, but I tried connecting directly to the IEXCloud API and it sent back responses super fast even for batches of stocks. 

I was also thinking it might be Heroku, but the long page loads happen both on the heroku app here: https://stock-scoreboard.herokuapp.com/ and when you run it locally on localhost.

So other candidates for the slowness might be the fact that I'm web-scraping the S&P 500 point value. Not sure if that takes a long time or not.

Another possibility is in stock_scoreboard.rb on line 32 and 33 I am iterating through every stock in the table one by one and calling StockQuote::Stock.quote(stock[:ticker]) individually each time. It might be faster to gather all the tickers and then send the API call once using the batch endpoint instead of sending multiple book calls. Not sure if that will be the performance improvement, but it's a possibility.

Not sure how you would think about figuring out which part of the app is causing the majority of the slowness, but that would be a huge thing to look at right now.