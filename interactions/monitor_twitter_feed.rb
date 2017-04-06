require "twitter"

module TwitterTIL
  TWITTER_CONSUMER_KEY        = ENV["TWITTER_CONSUMER_KEY"]
  TWITTER_CONSUMER_SECRET     = ENV["TWITTER_CONSUMER_SECRET"]
  TWITTER_ACCESS_TOKEN        = ENV["TWITTER_ACCESS_TOKEN"]
  TWITTER_ACCESS_TOKEN_SECRET = ENV["TWITTER_ACCESS_TOKEN_SECRET"]

  class MonitorTwitterFeed
    class << self
      def call
        client.user do |object|
          case object
          when Twitter::Tweet
            result = ParseTILEventFromTweet.call(object)
            event  = result.event
            next unless event
            log_event(event) { ApiToolbox::PostEventToAPI.call(event) }
          end
        end
      end

      private

      def log_event(event)
        puts "-" * 50
        puts "Posting event to API:"
        puts event
        yield if block_given?
        puts "==> OK"
        puts "-" * 50
      end

      def client
        @client ||= Twitter::Streaming::Client.new do |config|
          config.consumer_key        = TWITTER_CONSUMER_KEY
          config.consumer_secret     = TWITTER_CONSUMER_SECRET
          config.access_token        = TWITTER_ACCESS_TOKEN
          config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
        end
      end
    end
  end
end
