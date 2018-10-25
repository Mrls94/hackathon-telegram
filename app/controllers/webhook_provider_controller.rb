require 'telegram/message'

class WebhookProviderController < ApplicationController
  PROVIDERS = {
    'telegram' => 'Telegram'
  }.freeze

  def index
    RequestHandleWorker.perform_async(request_params.to_h)

    head :ok
  end

  def request_params
    hash = params.require(:webhook_provider).permit!
    hash[:provider] = params[:provider]
    hash
  end
end
