require 'telegram'
require 'telegram/commander'

Telegram::Commander.add_command(:createBoard) do |command|
  puts 'Doing the command dance!'
end
