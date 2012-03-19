class UsersController < ApplicationController
  before_filter :signed_in_user,     only: [:index, :edit, :update, 
                                            :following, :followers]
  before_filter :correct_user,       only: [:edit, :update]
  before_filter :admin_user,         only: :destroy

	def show
		@user = User.find params[:id]
    @microposts = @user.microposts.paginate page: params[:page]
	end

	def new
    if signed_in?
      redirect_to root_path
    else
		  @user = User.new
    end
	end

	def create
    if signed_in?
      redirect_to root_path
    else
      @user = User.new params[:user]
      if @user.save
        flash[:success] = "Welcome to the Sample App!"
        sign_into_session @user, permantently: false
        redirect_to @user
      else
        render 'new'
      end
    end
	end

  def edit
  end

  def update
    if @user.update_attributes params[:user]
      flash[:success] = "Profile updated"
      sign_into_session @user, permantently: cookies[:remember_token].nil?
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate page: params[:page]
  end

  def destroy
    user = User.find params[:id]
    if not current_user? user
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    else
      redirect_to users_path, notice: "Can't destroy yourself"
    end
  end

  def following
    @title = "Following"
    @user  = User.find params[:id]
    @users = @user.followed_users.paginate page: params[:page]
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find params[:id]
    @users = @user.followers.paginate page: params[:page]
    render 'show_follow'   
  end 

  private

    def correct_user
      @user = User.find params[:id]
      redirect_to root_path unless current_user? @user
    end

    def admin_user
      redirect_to root_path unless current_user.admin? 
    end
end
