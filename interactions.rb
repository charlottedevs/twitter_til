if ENV["RACK_ENV"] != "production"
  require "dotenv"
  Dotenv.load
end

require "api_toolbox"
require "twitter"

require_relative "interactions/monitor_twitter_feed"
require_relative "interactions/parse_til_event_from_tweet"
