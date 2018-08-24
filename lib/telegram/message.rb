require 'telegram'
require 'telegram/bot_command'

class Telegram::Message
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def sender
    @params['from']
  end

  def message_type
    return nil unless @params['entities'].try(:first)

    @params['entities'].first['type']
  end

  def text
    @params['text']
  end

  def entities
    @params['entities']
  end

  def command
    return nil unless command? || text.blank?
    return nil unless entities

    Telegram::BotCommand.new(text, entities.first)
  end

  def command?
    message_type == 'bot_command'
  end
end
