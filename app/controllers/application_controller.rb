class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    devise_user = super
    return nil unless devise_user
    devise_user.is_a?(Hash) ? User.find(devise_user['id'] || devise_user[:id]) : devise_user
  end
  helper_method :current_user
end
