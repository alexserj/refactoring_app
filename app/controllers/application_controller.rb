# app/controllers/application_controller.rb

# current_user is provider by Devise gem

class ApplicationController < ActionController::Base
  before_filter :set_current_profile

  # ...

  def current_profile
    current_user.try(:current_profile)
  end
  helper_method :current_profile

  # ...

  private

  # ...

  def set_current_profile
    return if params[:switch_profile].blank? || current_user.blank?

    profile = current_user.profiles.where(slug: params[:switch_profile]).first

    current_user.current_profile = profile if profile.present?
  end
end
