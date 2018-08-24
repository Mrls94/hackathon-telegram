require 'telegram'

class Telegram::BotCommand
  attr_reader :full_command

  def initialize(message_text, entity)
    @message_text = message_text
    @entity = entity

    parse_command
    parse_arguments
  end

  def parse_command
    @full_command = @message_text[0..(@entity['length'] - 1)]
  end

  def parse_arguments
    parse_command unless @command
    return @message_text[@command.size, @message_text.size] if @command
    @message_text
  end

  def arguments
    return [] unless @arguments

    @arguments.split(' ')
  end

  def command
    @full_command[1..-1].try(:to_sym)
  end

  def process
    Telegram::Commander.process(self)
  end
end
