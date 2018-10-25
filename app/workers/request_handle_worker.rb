class RequestHandleWorker
  include Sidekiq::Worker

  def perform(params = {})
    return if @provider_class.nil?

    message = @provider_class::Message.new(params[:message])
    handle_message message
  rescue StandardError => e
    Sidekiq.logger.debug "Error captured: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
  end

  def handle_message(message)
    return unless message.command?

    command = message.command
    if @provider_class::Commander.valid_command?(command.command)
      command.process(client)
    else
      client.send_message(text: "Command not found: '#{command.command}'", body: {})
    end
  end
end
