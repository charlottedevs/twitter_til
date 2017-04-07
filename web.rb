require "sinatra/base"

module TwitterTIL
  class Web < Sinatra::Base
    get "/" do
      "Monitoring Twitter stream... (#{Time.now})"
    end
  end
end
