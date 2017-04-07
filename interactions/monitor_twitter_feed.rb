
module TwitterTIL
  TWITTER_CONSUMER_KEY        = ENV["TWITTER_CONSUMER_KEY"]
  TWITTER_CONSUMER_SECRET     = ENV["TWITTER_CONSUMER_SECRET"]
  TWITTER_ACCESS_TOKEN        = ENV["TWITTER_ACCESS_TOKEN"]
  TWITTER_ACCESS_TOKEN_SECRET = ENV["TWITTER_ACCESS_TOKEN_SECRET"]

  class MonitorTwitterFeed
    class << self
      def call
        streaming_client.user do |object|
          case object
          when Twitter::Tweet
            result = ParseTILEventFromTweet.call(object)
            event  = result.event
            next unless event
            rest_client.favorite(object)
            handle_event(event)
          end
        end
      end

      private

      def handle_event(event)
        log_event(event) { ::ApiToolbox::PostEventToAPI.call(event) }
      end

      def log_event(event)
        puts "-" * 50
        puts "Posting event to API:"
        puts event
        yield if block_given?
        puts "==> OK"
        puts "-" * 50
      end

      def streaming_client
        @streaming_client ||= Twitter::Streaming::Client.new(&twitter_config)
      end

      def rest_client
        @rest_client ||= Twitter::REST::Client.new(&twitter_config)
      end

      def twitter_config
        lambda do |config|
          config.consumer_key        = TWITTER_CONSUMER_KEY
          config.consumer_secret     = TWITTER_CONSUMER_SECRET
          config.access_token        = TWITTER_ACCESS_TOKEN
          config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
        end
      end
    end
  end
end
