class UsersController < ApplicationController
	before_action :get_player, only: [:show]
	before_action :get_game_statistics, only: [:index]

	def index
	end

	def new
		@user = User.new
	end

	def show
	end

	def create
		if User.create(params_user)
			redirect_to users_path
		else
			redirect_to rankings_path
		ende
	end

	def update
	end

	private

	def params_user
		params.require(:user).permit(:id, :email, :password, :password_confirmation)
	end
end
