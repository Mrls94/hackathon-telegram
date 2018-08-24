class WebhookProviderController < ApplicationController
  def index
    user = @provider_class.get_user(params)
    client = @provider_class.new(user)

    body = {}
    client.send_message(text: "hello", body: body)

    head :ok
  end
end
