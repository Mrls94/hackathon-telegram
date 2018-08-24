require 'telegram/message'

class WebhookProviderController < ApplicationController
  def index
    user = @provider_class.get_user(params)
    client = @provider_class.new(user)
    body = {}
    message = Telegram::Message.new(params[:message].permit!)
    command = message.command

    if message.command?
      if Telegram::Commander.valid_command?(command.command)
        command.process
      else
        client.send_message(
          text: "Command not found: '#{command.command}'",
          body: body
        )
      end
    end
  rescue StandardError => e
    puts "Error captured: #{e.message}"
    puts e.backtrace.first(5).join("\n")
  ensure
    head :ok
  end
end
