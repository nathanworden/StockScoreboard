require "pg"
require "date"


class DatabasePersistence
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: "stock_scoreboard")
          end
    @logger = logger
  end

  attr_accessor :table_sort

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def add_position(ticker, shares, purchase_date, purchase_price, commission, s_and_p_at_stock_purchase_date)
    sql = "INSERT INTO stocks (ticker, shares, purchase_date, purchase_price, commission, s_and_p_at_stock_purchase_date) VALUES ($1, $2, $3, $4, $5, $6)"
    query(sql, ticker, shares, purchase_date, purchase_price, commission, s_and_p_at_stock_purchase_date)
  end

  def delete_position(ticker)
    sql = "DELETE FROM stocks WHERE ticker = $1"
    query(sql, ticker)
  end

  def get_position(ticker)
    sql = "SELECT * from stocks WHERE ticker = $1"
    result = query(sql, ticker)

    result.map do |tuple|
      tuple_to_list_hash(tuple)
    end[0]
  end

  def get_full_portfolio_cost_basis
    sql = "SELECT sum(shares * purchase_price) FROM stocks"
    result = query(sql)

    result.map do |tuple|
      tuple["sum"].to_f
    end[0]
  end

  def get_all_positions
    sql = "SELECT * from stocks"
    result = query(sql)

    result.map do |tuple|
      tuple_to_list_hash(tuple)
    end
  end

  def get_sandp_on(date)
    sql = "SELECT close_price from s_and_p WHERE hist_date = $1"
    result = query(sql, date)

    result.map do |tuple|
      tuple["close_price"]
    end[0].to_f
  end

  def add_yesterday_sandp(yesterday_sp_close)
    date = (Date.today) - 1
    result = 'before'
    if date.wday != 6 || date.wday != 0
      sql = "SELECT close_price from s_and_p WHERE hist_date = $1"
      result = (query(sql, date))
    end

    price_exists_in_database = !!(result.map {|ele| ele}[0])
    if !price_exists_in_database
      sql = "INSERT INTO s_and_p (hist_date, close_price) VALUES ($1, $2)"
      query(sql, date.to_s, yesterday_sp_close)
    end
  end

  def update_table_sort_rule(rule)
    sql = "UPDATE table_sort_rule SET sort_rule = $1"
    query(sql, rule)
  end

  def table_sort_rule
    sql = "SELECT * from table_sort_rule"
    result = query(sql)

    result.map do |obj|
      obj["sort_rule"].to_sym
    end[0]
  end

  def disconnect
    @db.close
  end

  def tuple_to_list_hash(tuple)
    {ticker: tuple["ticker"],
     shares: tuple["shares"].to_f,
     purchase_date: tuple["purchase_date"],
     purchase_price: tuple["purchase_price"].to_f,
     commission: tuple["commission"].to_f,
     s_and_p_at_stock_purchase_date: tuple["s_and_p_at_stock_purchase_date"].to_f
    }
  end
end