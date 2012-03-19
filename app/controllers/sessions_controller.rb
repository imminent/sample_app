class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by_email params[:email]
		if user && user.authenticate(params[:password])
			sign_into_session user, permanently: params[:remember_me]
			redirect_back_or user
		else
			flash.now[:error] = 'Invalid email/password combination' # Not quite right!
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
