class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    return @_resolved_current_user if defined?(@_resolved_current_user)
    devise_user =
      begin
        warden.authenticate(scope: :user)
      rescue ArgumentError
        warden.logout(:user)
        nil
      end
    @_resolved_current_user =
      if devise_user.nil?
        nil
      elsif devise_user.is_a?(Hash)
        User.find(devise_user['id'] || devise_user[:id])
      else
        devise_user
      end
  end
  helper_method :current_user
end
