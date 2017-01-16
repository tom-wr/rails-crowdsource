class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #call the configure params before devise actions
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_filter :authenticate_user!
  helper_method :current_user

  def current_user
    super || guest_user
  end

  private
  def guest_user
    User.find(session[:guest_user_id].nil? ? session[:guest_user_id] = create_guest_user.id : session[:guest_user_id])
  end

  def create_guest_user

    user = User.new { |user| user.guest = true }
    name_tag = "#{Time.now.to_i}#{rand(99)}"
    user.username = "Guest #{name_tag}"
    user.email = "#{name_tag}@americanairmuseum.org.uk"
    user.save(:validate => false)
    user

  end
  # protect the database, while allowing these fields to be updated.
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me, :guest) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :password_confirmation, :remember_me, :guest) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:email, :password, :password_confirmation, :remember_me, :guest) }
  end

end
