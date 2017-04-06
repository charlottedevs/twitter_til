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

  private

  def build_event
    return unless valid_til_tweet?

    OpenStruct.new.tap do |obj|
      obj.event = build_event_params
    end
  end

  def build_event_params
    {
      category: "til-tweets",
      user_id:  user_id,
      info:     {
        twitter_handle: handle,
        text:           tweet_text,
        url:            tweet_url
      }

    }
  end

  def user_id
    ApiToolbox::FetchUser.call(user_params: { twitter_handle: handle })
  end

  def valid_til_tweet?
    mentioned? && til_tweet?
  end

  def mentioned?
    tweet.user_mentions.map(&:screen_name).include? "cltjrdevs"
  end

  def til_tweet?
    tweet.hashtags.map(&:text).any? { |hshtg| hshtg =~ /^til$/i }
  end

  def handle
    tweet.user.handle
  end

  def tweet_text
    tweet.text
  end

  def tweet_url
    tweet.uri.to_s
  end
end
