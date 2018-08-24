class Telegram::Message
  def initialize(params)
    @params = params
  end

  def sender
    @params['from']
  end

  def message_type
    @params['entities'].first['type']
  end

  def text
    @params['text']
  end

  def command
    return nil unless message_type == 'bot_command' || text.blank?

    Telegram::Command.new(text, @params['entities'].first)
  end
end
