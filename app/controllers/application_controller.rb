class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json{head :forbidden}
      format.html{redirect_to main_app.root_url, alert: exception.message}
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    flash[:warning] = exception.message
    redirect_to root_url
  end

  def check
    if user_signed_in?
      unless current_user.is_admin?
        flash[:error] = "You can not go to page admin"
        redirect_to root_path
      end
    else
      flash[:error] = "You can not go to page admin"
      redirect_to root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: [:name]
    devise_parameter_sanitizer.permit :sign_in, keys: [:name]
    devise_parameter_sanitizer.permit :account_update, keys: [:avatar, :name, :address, :phone]
  end
end
