class Post < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :content
	validates_presence_of :scheduled_at
	validates_length_of :content, maximum:140, message: "Less than 140 please"
	validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now
	after_create :schedule

	def schedule
		begin
			ScheduleJob.set(wait_until: scheduled_at).perform_later(self)
			self.update_attributes(state: "scheduled")
		rescue Exception => e
			self.update_attributes(state: "scheduling failed", error: e.message)
		end
	end

	def display
		begin
			if not state == 'canceled'
				if twitter == true
					to_twitter
				end
				self.update_attributes(state: "posted")
			end
		rescue Exception => e
			self.update_attributes(state: "posting error", error: e.message)
		end

	end


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
