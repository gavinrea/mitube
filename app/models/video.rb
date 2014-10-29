class Video < ActiveRecord::Base
	#regular expression to confirm youtube link
	YT_LINK_FORMAT = /\A.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
	#
	validates :link, presence: true, format: YT_LINK_FORMAT

	#will execute before video is created, so we can verify URL
	before_create  do
		#produces link object that acts as array
		uid = link.match(YT_LINK_FORMAT)
		# verify object and set uid
		self.uid = uid[2] if uid && uid[2]
		# has to be 11 to be a valid uid
		if self.uid.to_s.length != 11
			self.errors.add(:link, 'is invalid.')
			false
		#if it's the same uid as any other video
	elsif Video.where(uid: self.uid).any?
		self.errors.add(:link, 'is not unique.')
		false
	else
		get_additional_info
	end
end

def user_params
		# call this method in controller to prevent the user from passing in other info
		params.require(:user).permit(:link)
	end

# means' we can't access this function outside the class. NO Video.get_additional_info
private

def get_additional_info
	begin
		client = YouTubeIt::Client.new(:dev_key =>  'AIzaSyAkCoPPcM9Y7wwUBvxwx3jVTLJSXrXRbpQ')
			#searches fo the video using uid
			video  = client.video_by(uid)
			#set all vars from the found vido
			self.title = video.title
			self.duration = parse_duration(video.duration)
			self.author = video.author.name
			self.likes = video.rating.likes
			self.dislikes = video.rating.dislikes
		rescue Exception => e
			self.errors.add(:link, "something went wrong. : #{e}")
			return false
		end
	end

	def parse_duration(d)
		hr = (d / 3600).floor
		min = ((d - (hr * 3600)) / 60).floor
		sec = (d - (hr * 3600) - (min * 60)).floor
		hr = '0' + hr.to_s if hr.to_i < 10
		min = '0' + min.to_s if min.to_i < 10
		sec = '0' + sec.to_s if sec.to_i < 10
		hr.to_s + ':' + min.to_s + ':' + sec.to_s
	end

	
end
