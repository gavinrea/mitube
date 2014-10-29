class Video < ActiveRecord::Base

	def user_params
		# call this method in controller to prevent the user from passing in other info
		params.require(:user).permit(:link)
	end
end
