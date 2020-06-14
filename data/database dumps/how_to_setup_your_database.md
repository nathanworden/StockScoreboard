In terminal:

1. To get the most updated version of the app: `git pull` 
2. From the root folder of the app, go to `./data/database\ dumps/`

2. If you don't have a database named `stock_scoreboard` yet, got to step 4. If you already have a database named `stock_scoreboard` with old data in it, as far as I can tell you need to drop it, because "updating" doesn't really work.

3. Go into another database and then: `DROP DATABASE stock_scoreboard`. Then jump back out to terminal.
4. Create an empty database with the same name: `createdb stock_scoreboard`
5. Restore the database dump: `psql stock_scoreboard < infile` where infile is the most recent database dump. Presently that would be `06132020_stock_scoreboard_dump`.

