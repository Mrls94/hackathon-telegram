class Telegram::Commander
  class << self
    attr_reader :commands

    def add_command(name, &block)
      @commands ||= {}
      @commands[name] = block
    end

    def valid_command?(command)
      @commands.key?(command)
    end

    def process(telegram_command)
      return false unless telegram_command
      return false unless valid_command?(telegram_command.command)

      @commands[telegram_command.command].yield(telegram_command)
    end
  end
end
