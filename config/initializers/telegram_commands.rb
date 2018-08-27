require 'telegram/commander'

Telegram::Commander.add_command(:create_board) do |client|
  client.send_message(text: "First things first: Set your Trello board by using the command `/trello_board_id <board_id>`", body: {})
end

Telegram::Commander.add_command(:trello_board_id) do |client, command|
  client.send_message(text: "Great! I got your board id: #{command.args.first}", body: {})
  client.send_message(text: "Now I need your Trello Access Token. Please use `/trello_access_token <access_token>`", body: {})
end

Telegram::Commander.add_command(:trello_access_token) do |client, command|
  client.send_message(text: "Great! I got your access_token: #{command.args.first}", body: {})
  client.send_message(text: "Creating necessary columns...", body: {})
end
