class WebhookProviderController < ApplicationController
  def index
    user = "#{params[:provider]}_service".camelcase.constantize.send(:get_user, params)
    client = "#{params[:provider]}_service".camelcase.constantize.send(:new, user)

    body = {}
    client.send_message(text: "hello #{params[:message]['from']['first_name']}", body: body)

    head :ok
  end
end
