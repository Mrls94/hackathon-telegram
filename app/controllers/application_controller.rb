class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :detect_provider_class

  protected

  def user
    @user ||= @provider_class.get_user(params)
  end

  def client
    @client ||= @provider_class.new(user)
  end

  def detect_provider_class
    @provider_class = "#{params[:provider]}_service".camelcase.constantize
  rescue StandardError => _e
    Rails.logger.debug("Provider '#{params[:provider]}' not found")
  end
end
