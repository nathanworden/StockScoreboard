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
    @logger.info "#{statment}: #{params}"
    @db.exec_params(statement, params)
  end

  def disconnect
    @db.close
  end
end