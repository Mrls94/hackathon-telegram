class RequestHandleWorker
  include Sidekiq::Worker
  require_all 'lib'

  def perform(params = {})
    @params = params
    return if provider.nil?

    message = provider::Message.new(params['message'])
    handle_message message
  rescue StandardError => e
    puts "Error captured: #{e.message}\n#{e.backtrace.first(5).join("\n")}"
  end

  private

  def provider
    @provider ||= "#{@params['provider']}".camelcase.constantize
  end

  def provider_class
    @provider_class ||= "#{@params['provider']}_service".camelcase.constantize
  end

  def user
    @user ||= provider_class.get_user(@params)
  end

  def client
    @client ||= provider_class.new(user)
  end

  def handle_message(message)
    return unless message.command?

    command = message.command
    if provider::Commander.valid_command?(command.command)
      command.process(client)
    else
      client.send_message(text: "Command not found: '#{command.command}'", body: {})
    end
  end
end
