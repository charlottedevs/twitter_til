require "sinatra/base"

if ENV["RACK_ENV"] != "production"
  require "dotenv"
  Dotenv.load
end

module TwitterTIL
  class Web < Sinatra::Base
    get "/" do
      "Monitoring Twitter stream... (#{Time.now})"
    end
  end
end
