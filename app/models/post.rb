class Post < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :scheduled_at
	validates_length_of :content, maximum:140, message: "Less than 140 please"
	validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now


	def to_twitter
		
		client = Twitter::REST::Client.new do |config|
			config.access_token = self.user.twitter[0].oauth_token
			config.access_token_secret = self.user.twitter[0].secret
			config.consumer_key = ENV['TWITTER_KEY']
			config.consumer_secret = ENV['TWITTER_SECRET']
		end
		client.update(self.content)
	end
end
