**[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)**[10:46 PM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592286391000400)

Hi Dan!I noticed your message in the general chat and thought I would reach out.

[10:46](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592286416001100)

What part of the Launch School curriculum are you in?

[10:48](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592286515003100)

I have an open-source project I started that I think is a great way for people to put to work what they are learning in Launch School, but I don't want to distract you from what you'd be learning in Core. If you're just starting Launch School, then this probably would be a distraction. But if you're near the end, it might be a fun project to contribute to to tie everything you learn at Launch School together.

Today

![img](https://ca.slack-edge.com/T0YKP5Z9T-U015188NYUX-0ac326a379f6-48)

**[Dan Christan](https://app.slack.com/team/U015188NYUX)**[3:38 AM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592303922003900)

Hey Nathan, I’m working my way through the second lesson in the first part of the Ruby course actually.I’m in a bit of a weird position with this material as I’m a self taught programmer with a couple of uni electives in coding and released my first software over 15 years ago. I do development in Python for algorithmic trading, telecommunications, and machine learning applications so I can do some rather advanced things, but have a poor foundation. I need to learn Ruby for job I’m being offered and figured this would be a good way to fill in my knowledge gaps, and get a respectable certification as well as get a portfolio together that isn’t a disjointed mishmash.Anyway, I’d love to hear about your open source project. Lay it on me.

![img](https://ca.slack-edge.com/T0YKP5Z9T-UCUV037NV-146ffde5e55d-48)

**[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)**[9:22 AM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592324561011100)

Very cool! Thanks for providing that background.The project that I am creating is a stock scoreboard app: https://stock-scoreboard.herokuapp.com/There are a million of them, but there are a handful I am keeping my eye on that I think could get pretty big. I think it's too late to compete in this space ('this space' meaning "Bloomberg terminal for the retail investor"), but my thinking is that if you've contributed to an open source project like this it will both help solidify the fundamentals Launch School is teaching and look good on a resume.My version was created from looking at a screen shot of The Motley Fool's old Stock Scorecard dashboard, which they discontinued in September of last year. I had been using it for six years and was pretty bummed when they pulled the plug. It left a hole I thought I could fill, so I thought I'd try making my own.The direction I want to take mine in is to be able to compare your returns vs those of your friends and against all other users that sign up. In my opinion that kind of sharing and comparing is going to be inevitable.Anyway, if that sounds like your cup of tea just let me know and I can share the Github repository with you and give instructions for a pull request. I have tons of ideas of bunches of things that can be added, so there's no shortage of ways to contribute.

Short list of similar products that are in development or have already launched:
https://commonstock.com/
https://feyapp.com/
https://www.koyfin.com/
https://atom.finance/home?
https://www.wealthbase.com/
https://www.rafa.ai/
https://www.morningstar.com/portfolio-manager


![img](https://ca.slack-edge.com/T0YKP5Z9T-U015188NYUX-0ac326a379f6-48)

**[Dan Christan](https://app.slack.com/team/U015188NYUX)**[4:11 PM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592349088000300)

Hey Nathan, so the thing about the Bloomberg Terminal is not that it has millions of competitors. It has maybe 2-4. The reason why people use software like that is because the analysis interface they have is built using proprietary or heavily customized technology that is able to display and compare volumes of data that will bring any non-exotic web framework that currently exists to it’s knees by a factor of 5-10, load and swap that data quickly, and they have proprietary data feeds.To make something on that level you’d need to build a custom fully featured data framework using something like WebAssembly Blazor that is optimized to the teeth, broker deals with dozens of data providers for millions of dollars, and then add literally hundreds of features.I’ve built a miniature Bloomberg which does that for just one financial data feed and it was a nightmare to do. I ended up using an optimization technique which only worked for that data and tons of backend pre-processing, massive caches etc. Like I said nightmare.The Koyfin example you added is extremely interesting though! They’re trying to use ultra optimized React with all sorts of priority tricks to be competitive, which is similar to the hack I tried to do. It runs 3x slower than their competition meaning it will melt low-end PCs, but it’s really nice work. It’s 318,000+ lines of code though.What you’re going for is more of a portfolio app, which there are tons of. This is not focused on data but rather interesting features UI. Definitely seems fun to work on.Anyway, I’m a newbie to Ruby and launcschool’s design process and the sort of collaboration they advocate so I’d love to help with a project and figure out how to work together properly. I ended up creating a new Github (Aperions) as my main one is mess of projects instead of a proper portfolio.Let me know how to get added.

![img](https://ca.slack-edge.com/T0YKP5Z9T-UCUV037NV-146ffde5e55d-48)

**[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)**[8:00 PM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592362822003400)

Yeah, that does sound like quite the undertaking. Very cool project though- did you build your mini Bloomberg as a personal project or for a business use case?Sweet! Well this will be fun. To become a contributor:

1. Go to the Stock Scoreboard repository: https://github.com/nathanworden/StockScoreboard

2. Click the little 'fork' button in the top right. The new fork will then be on your repositories at  [github.com/[your_user_name\]/[repo_name]](http://github.com/[your_user_name]/[repo_name]).

3. Clone the repo down to your computer: click the 'clone' button from your repo fork on GitHub, copy the SSH or https endpoint then move over to your terminal and run `git clone [your pasted endpoint from GitHub]`

4.  `cd` into the directory, then open up `stock_scoreboard.rb`, the main app.

   **[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)** [34 minutes ago](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592362869003600?thread_ts=1592362822.003400&cid=D015ENDDAAZ)

   A quick tour:

   - `line 1`: `require "sinatra"` I'm using the Sinatra Framework, which you use for projects in Launch School in RB 175.
   - `line 5`: `require "stock_quote"` The gem I'm using to pull market data is called 'stock quote'. This is provided by IEX Cloud which is the guys in the book "Flash Boys" by Michael Lewis. ![:raised_hands:](https://a.slack-edge.com/production-standard-emoji-assets/10.2/apple-medium/1f64c.png)
   - `line 7`: `require_relative "./data/s_and_p_data/scrape_todays_s_and_p.rb"` I'm currently web scraping the data from the previous day's S&P 500 close and adding that to my PostgreSQL data base.
   - `line 93`: `get "/" do` The main route. When someone loads up the app for the first time it goes out and gets current market data from all the stocks in the database and then processes that data against the user entered data about when and how much they bought a security for.

   Back out in the directory:

   - `database_persistence.rb` Is where SQL queries the database to be spit back out to the main app.

   - `views/layout` Is the main template

   - `stock_table` Is everything below the 'Balances, Performance, Allocation" line.

   - `public` is where the css files live

     .**[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)** [8:01 PM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592362911004000)

     I'm guessing you would prefer to work on back-end stuff, but just tell me where your interests lie.
     (if you want to do some front end stuff I think it would be awesome to build a chart of the portfolio under the 'Performance Tab', that would actually require both some front end and back end work).

     Right now my most frustrating problem is how long the page takes to load. It can easily take 8-16 seconds on every refresh, which is annoyingly long. I was thinking that was because of the time it takes to get the data from the gem, but I did some testing and now I don't think so.

     The testing I did:My hypothesis was that the more stocks you added to the table, the slower the gem would run. But I tested it by using an HTTPie (A HTTP command line client, you can download it here: https://httpie.org/docs#installation).If you use HTTPie to make a HTTP request directly to IEX Cloud, you get a response back like right away.Here are the docs for IEX Cloud: https://iexcloud.io/docs/api/#batch-requestsHere is an example of the batch request I did where I got a response back right away for multiple stocks:
     `http ``https://cloud.iexapis.com/stable/stock/market/batch``\?symbols\=dis,twou,sq,amzn,fvrr,fivn,shop,crwd,lvgo,work,flgt,rdfn\&types\=quote,chart\&range\=1m\&last\=5\&token\=pk_fc4bf13336e54aa8b8a63f36d3cd05f0``http` at the beginning is the HTTPie syntax.
     The token at the end is my personal one- you might want to sign up for a free account and get your own individual token so we don't run out of messages fast. (edited) 

     ![img](https://ca.slack-edge.com/T0YKP5Z9T-UCUV037NV-146ffde5e55d-48)

     **[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)**[21 minutes ago](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592363716005300?thread_ts=1592362971.004500&cid=D015ENDDAAZ)

     One thing I just realized is that in `stock_scoreboard.rb` on line 32 and 33 I am iterating through every stock in the table one by one and calling `StockQuote::Stock.quote(stock[:ticker])` individually each time. It might be faster to gather all the tickers and then send the API call once using the `batch` endpoint instead of sending multiple `book` calls. Not sure if that will be the performance improvement, but it's a possiblity.

     The slowness might also be being caused by how I am web scraping on every refresh and displaying it up on the top under 'Today's S&P 500'.

     The web-scraping is happening in `"./data/s_and_p_data/scrape_todays_s_and_p.rb"`Essentially, I am using a gem called Nokogiri to go to [cnbc.com](http://cnbc.com/) and using css classes to find the box on their page where they display the current point total of the S&P 500 and the S&P500 percent. I'm guessing this might be a slow process, plus its not super robust because all they have to do is change the styling or placement of this on the page and my code will break.The reason I did this was because I was having a hard time finding how to use the `stock-quote` gem to get the current point value of the S&P 500. I was under the impression that they only had listed securities and not the point value of the S&P 500 itself. But maybe I need to look closer at the documentation. I made that decision when I was less familiar with the docs.If we can call an API or use a gem to grab the current value of the S&P500 that would be more robust than web scraping it.

     Another design decision that might make things seem faster is updating the way the table columns sort.

     Currently, the whole page refreshes if you click on any of the table column heads. A better way to do this would probably be to somehow save all the data in a session and instead of re-calling the most up to date data from the gem, just re-arranging the current data.The user probably isn't expecting to get a new refresh when they try and sort a column table, so why make them wait for a refresh if all they want to do is sort the table data differently?

     If you make any changes:

     1.  `git commit` your changes, then `git push origin master` to push your changes to GitHub to make your fork on GitHub contain the changes you intent to contribute.
     2. Got to https://github.com/nathanworden/StockScoreboard/pulls and click 'new pull request', then 'compare across forks', then on the right side select your username from the drop down.
     3. Click the 'create pull request' button and then I'll be able to see your changes and we can talk about the code!

     You're free to contribute in whatever way you see fit (or not at all)! If you want to jump on a call and talk face to face about any questions you have I'm down for that too!





### 6/17/20

![img](https://ca.slack-edge.com/T0YKP5Z9T-U015188NYUX-0ac326a379f6-48)

**[Dan Christan](https://app.slack.com/team/U015188NYUX)**[1:59 AM](https://launchschool.slack.com/archives/D015ENDDAAZ/p1592384396000300)

The mini Bloomberg was for a small investment business. I’m decently well versed in front-end for HTML, CSS, graphics, bootstrap, SVG, JavaScript, jQuery, some React, and D3. However you’re right that I’d prefer to work on the Ruby back-end as that’s my weakness.I think I’ll start by making a few small tweaks so that way I know how everything is structured and why, and make a few adjustments to the front-end look and run all that by you. I saw you’re a photographer too, ha ha I helped pay for some of my education doing that, but never did it full time. I did products/landscapes/buildings -- essentially anything static.Can you walk me through the current structure of the app and how the components fit together? Are you trying to follow a specific model architecture? Was it based on a template?I’ll see if I can tackle the data issue after that.

**[Nathan Worden (230)](https://app.slack.com/team/UCUV037NV)** 

Yeah I got really into wedding photography and senior photos and that basically paid my way through college. I still shoot about four weddings a year which is fun. Definitely a great creative outlet. If you have a portfolio site, I'd love to take a look! I never really did landscapes/buildings, but I appreciate the work of those that do!So, for the current structure of the app- its based off of a todo app that Launch School teaches you how to build in RB 175. I attached the video Launch School uses to introduce the project template, and here is the download they give you to set things up: https://da77jsbdz4r05.cloudfront.net/templates/sinatra_todos_r20160624.zipBut the general structure of needing things like a Gemfile, Gemfile.lock, config.ru, and a public and views folder are necessary components of Ruby Apps. And I think specifically Sinatra.As far as a specific model architecture, I'm not sure what the model architecture is called- but I think about it visually like in the screenshot diagram below. The app (`stock_scoreboard.rb`) tells the scraper (`scrape_todays_s_and_p`) to go get the S&P 500 data, which is stored in a database (`database_persistence`) . The user can enter their positions in the app, which stores that data in the database. The app pulls the data out of the database, manipulates it, and then spits it out and displays it on `layout.erb`, `stock_table.erb` and `add_position.erb`I can walk you through how the components fit together in more detail, but to do that you'll need a local database, so here are instructions on that: (edited) 

To run the app locally on your computer you'll have to set up a local PostgreSql database. If you are on a mac you can install Postgres with Homebrew (https://brew.sh/). Terminal commands:
`brew install postgres`
`brew tap homebrew/services`
`brew services start postgresql`
For more detail on how to install PostgreSQL for Mac OSX, see here: https://launchschool.com/blog/how-to-install-postgresql-on-a-mac/Now you should be able to create an empty local postgreSQL database named 'stock_scoreboard': `createdb stock_scoreboard`Now we are going to fill the database with some seed data. From the root folder of the stock_scoreboard app, go to `./data/database\ dumps/`Restore the database dump: `psql stock_scoreboard < infile` where 'infile' is the most recent database dump. Presently that would be `06132020_stock_scoreboard_dump.sql`The database dump will create tables in your stock_scoreboard database which have:

- A table named `s_and_p`: S&P500 data going back to the year 1900.
- A table named `stock` :s A small portfolio with some stocks like 'RCL', 'XOM', and 'F'
- A table named `time_weighted_return` : A table that holds data necessary to calculate the time weighted return.
- A table named `table_sort_rule` : A table that just stores which column the stock table is sorted by. This is a bad way to do this. I don't think I need to be storing in a database what the current way is to sort the table.

Run `bundle install` to install all the gem dependencies.
And now if you run `bundle exec ruby stock_scoreboard.rb` it should run the app locally and you can check it out in your browser at `http://localhost:4567/`You might have some trouble with the ruby version and bundler, so let me know if you can't get it up and running.

How the components fit together:

- `line 93 and 94` in `stock_scoreboard`: The app queries the database and gets all the current positions.
- `line 95` : The app asks the database to get the total amount invested, and store it in a variable called `@total_portfolio_cost_basis`, this instance variable is accessible by `layout.erb`. If you open up `layout.erb` and go to line 44 you can see where it is being used.
- `line 96` : A helper method called `pull_market_data` is used. We pass in the `all_positions` and `@total_portfolio_cost_basis` variables so that it can do it's work.
- All the calculations happen in the `pull_market_data` method, which is up on `line 28`. All the numbers you see both up top and in the stock table below for each position are calculated here. `pull_market_data` uses `each` to loop through each `stock` . (Each `stock` in `all_positions` is a hash, and we add a bunch of keys and values for each data metric like `latest_price`.
- `all_positions.each do` returns the calling object, which is `all_positions` but now the `stocks` in `all_positions` have been mutated with all this new data. Back down on `line 96` we save this in the instance variable `@all_positions`.

I could keep going with a play by play of what is going on- but I'm not sure if I'm overdoing it or missing important questions you may have. I'm down to jump on a call, or answer more specific questions, or just keep going.