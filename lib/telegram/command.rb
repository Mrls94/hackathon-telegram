class Telegram::Command
  attr_reader :command

  def initialize(message_text, entity)
    @message_text = message_text
    @entity = entity

    parse_command
    parse_arguments
  end

  def parse_command
    @command = @message_text[@entity['offset']..(@entity['length'] - 1)]
  end

  def parse_arguments
    parse_command unless @command

    @arguments_text = @message_text[@command.size, @message_text.size]
  end

  def arguments
    @arguments.split(' ')
  end
end
