class UsersController < ApplicationController

	before_action :check_session, except: :create

	 def show
    user = User.find(params[:id])
    
    render json: user
  end

  def create
    user = User.new(register_params)

    if user.save
      if status.create(user.id)
        render json: {success: "Resource created", user: remove_unsafe_keys(user) }.to_json, status: 201
      else
        resource_could_not_be_created 
      end
    else
      check_errors_or_500(user)
    end
  end

  def update
    user = User.find(params[:id])

    return not_authorized unless current_user == user 

    if user.update_attributes(update_params)
      render json: user, status: 200
    else
      check_errors_or_500(user)
    end

  end

	def destroy
    user = User.find_by_id(params[:id])

    return not_authorized unless current_user == user

    if user.destroy
      render json: {success: "User deleted"}.to_json
    else
      # TODO: Should be logged
      render json: {error: "Could not delete user"}.to_json, status: 500
    end
  end

  # Used in SessionsController#create
  def self.authenticate(email, password)
   
    user = User.find_by_email_and_password(email, password)

    return not_authorized if user.empty?
    
    user

  end

	private

	def remove_unsafe_keys(user)
    user.slice('id', 'name', 'email')
  end

  def register_params 
    params.require(:user).permit(:name, :email, :password)
  end

  def update_params 
    params.require(:user).permit(:name, :email, :password)
  end

end
