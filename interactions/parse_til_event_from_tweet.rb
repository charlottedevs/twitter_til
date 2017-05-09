module TwitterTIL
  class ParseTILEventFromTweet
    class << self
      def call(tweet)
        new(tweet).build_event
      end
    end

    attr_reader :tweet

    def initialize(tweet)
      @tweet = tweet
    end

    def build_event
      OpenStruct.new.tap do |obj|
        obj.event = valid_til_tweet? ? build_event_params : nil
      end
    end

    private

    def build_event_params
      {
        event: {
          category: "til-tweets",
          user_id:  user_id,
          info:     info_params
        }
      }
    end

    def info_params
      {
        twitter_handle: handle,
        text:           tweet_text,
        url:            tweet_url
      }
    end

    def user_id
      result = ::ApiToolbox::FetchUser.call(
        user_params: { search: "twitter_handle", value: handle }
      )
      result.user["id"] if result.user
    end

    # Uncomment below to filter messages to only messages
    # where CLTJRDEVS is @mentioned.
    def valid_til_tweet?
      user_id && til_tweet? # && mentioned?
    end

    def mentioned?
      tweet.user_mentions.map(&:screen_name).include? "cltjrdevs"
    end

    def til_tweet?
      tweet.hashtags.map(&:text).any? { |hshtg| hshtg =~ /^til$/i }
    end

    def handle
      tweet.user.screen_name
    end

    def tweet_text
      tweet.text
    end

    def tweet_url
      tweet.uri.to_s
    end
  end
end
