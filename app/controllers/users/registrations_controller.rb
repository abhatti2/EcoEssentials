class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :email, :password, :password_confirmation, :first_name, :last_name, :address, :city, :postal_code, :phone, :province ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :email, :password, :password_confirmation, :current_password, :first_name, :last_name, :address, :city, :postal_code, :phone, :province ])
  end

  # Redirect to a specific path after sign-up
  def after_sign_up_path_for(resource)
    root_path # Change this to another path if needed
  end

  # Redirect to a specific path after updating account
  def after_update_path_for(resource)
    edit_user_registration_path # Redirect back to the edit profile page
  end
end
