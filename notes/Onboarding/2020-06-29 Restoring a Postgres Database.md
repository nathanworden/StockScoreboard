# Restoring a Postgres Database



https://devcenter.heroku.com/articles/heroku-postgres-import-export



### [Download backup](https://devcenter.heroku.com/articles/heroku-postgres-import-export#download-backup)

To export the data from your Heroku Postgres database, create a new backup and download it.

```term
$ heroku pg:backups:capture
$ heroku pg:backups:download
```

### [Restore to local database](https://devcenter.heroku.com/articles/heroku-postgres-import-export#restore-to-local-database)

Load the dump into your local database using the [pg_restore](http://www.postgresql.org/docs/current/static/app-pgrestore.html) tool. If objects exist in a local copy of the database already, you might run into inconsistencies when doing a `pg_restore`.

This will usually generate some warnings, due to differences between your Heroku database and a local database, but they are generally safe to ignore.

```term
$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump
```



--------

### Monday, June 29th, 2020

From within this folder:

`data/datbase dumps/heroku dumps/06292020_heroku_stock_scoreboard.dump`

Run:

`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb 06292020_heroku_stock_scoreboard.dump`

Where `myuser` is your user on your computer and `mydb` is `stock_scoreboard`

