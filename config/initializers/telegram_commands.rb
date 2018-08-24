require 'telegram/commander'

Telegram::Commander.add_command(:createBoard) do |client, command|
  client.send_message(text: "Let\'s start by setting your Trello board. Please send the board ID", body: {})
end
