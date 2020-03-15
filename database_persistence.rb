require "pg"


class DatabasePersistence
  def initialize(logger)
    @db = if Sinatra::Base.production?
            PG.connect(ENV['DATABASE_URL'])
          else
            PG.connect(dbname: "stock_scorecard")
          end
    @logger = logger
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def add_position(ticker, shares, purchase_date, purchase_price, comission)
    sql = "INSERT INTO stocks (ticker, shares, purchase_date, purchase_price, comission) VALUES ($1, $2, $3, $4, $5)"
    query(sql, ticker, shares, purchase_date, purchase_price, comission)
  end

  def get_position(ticker)
    sql = "SELECT * from stocks WHERE ticker = $1"
    query(sql, ticker)
  end

  def get_all_positions
    sql = "SELECT * from stocks"
    result = query(sql)

    result.map do |tuple|
      tuple_to_list_hash(tuple)
    end
  end

  def disconnect
    @db.close
  end

  def tuple_to_list_hash(tuple)
    {ticker: tuple["ticker"],
     shares: tuple["shares"].to_f,
     purchase_date: tuple["purchase_date"],
     purchase_price: tuple["purchase_price"],
     comission: tuple["comission"]}
  end
end