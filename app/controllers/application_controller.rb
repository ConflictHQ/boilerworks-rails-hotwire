class ApplicationController < ActionController::Base
  include Authentication
  include Pundit::Authorization
  include SetCurrentAttributes
  include Pagy::Method

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Pundit expects current_user; Rails 8 auth uses Current.user
  def current_user
    Current.user
  end
  helper_method :current_user

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end
end
