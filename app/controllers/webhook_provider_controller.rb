require 'telegram/message'

class WebhookProviderController < ApplicationController
  def index
    user = @provider_class.get_user(params)
    client = @provider_class.new(user)
    body = {}
    message = Telegram::Message.new(params[:message].permit!)
    command = message.command

    if message.command?
      client.send_message(
        text: "Your trying to execute command '#{command.command}' with arguments: #{command.arguments}",
        body: body
      )
    end

    head :ok
  end
end
