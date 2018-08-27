require 'telegram/message'

class WebhookProviderController < ApplicationController
  def index
    message = Telegram::Message.new(params[:message])

    if message.command?
      command = message.command
      if Telegram::Commander.valid_command?(command.command)
        command.process(client)
      else
        client.send_message(text: "Command not found: '#{command.command}'", body: {})
      end
    end
  rescue StandardError => e
    Rails.logger.debug "Error captured: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
  ensure
    head :ok
  end
end
