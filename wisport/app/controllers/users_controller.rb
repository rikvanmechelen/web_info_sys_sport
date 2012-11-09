class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]

	def index
		@users = User.all
	end
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Thank you for signing up! You are now logged in."
    else
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
		@exercises = @user.exercises.paginate(:page => params[:page])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
  end

	def follow
		@user = User.find_by_id(params[:id])
		@current_user.friends << @user unless @current_user.friends.include? @user
		respond_to do |format|
			format.html
			format.js
		end
	end
	def unfollow
		@user = User.find_by_id(params[:id])
		@current_user.friends.delete(@user) if @current_user.friends.include? @user
		respond_to do |format|
			format.html
			format.js
		end
	end
end
