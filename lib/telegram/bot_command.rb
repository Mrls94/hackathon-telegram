require 'telegram'

class Telegram::BotCommand
  attr_reader :full_command, :message_text, :entity

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
    parse_command unless @full_command
    if @full_command
      @arguments = @message_text[(@full_command.size + 1)..-1]
    else
      @message_text
    end
  end

  def arguments
    return [] unless @arguments

    @arguments.split(' ')
  end

  def args
    arguments
  end

  def command
    @full_command[1..-1].try(:to_sym)
  end

  def process(client)
    Telegram::Commander.process(client, self)
  end
end
