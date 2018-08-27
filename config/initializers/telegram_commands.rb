require 'telegram/commander'

Telegram::Commander.add_command(:create_board) do |client|
  client.send_message(text: "First things first: Set your Trello board by using the command `/trello_board_id <board_id>`", body: {})
end

Telegram::Commander.add_command(:trello_board_id) do |client, command|
  client.user.add_task_manager_info(:trello, :board_id, command.args.first)
  client.send_message(text: "Great! I got your board id: #{command.args.first}", body: {})
  client.send_message(text: "Now I need your Trello Access Token. Please use `/trello_access_token <access_token>`", body: {})
end

Telegram::Commander.add_command(:trello_key) do |client, command|
  client.user.add_task_manager_info(:trello, :key, command.args.first)
  client.send_message(text: "Great! I got your key: #{command.args.first}", body: {})
end

Telegram::Commander.add_command(:trello_token) do |client, command|
  client.user.add_task_manager_info(:trello, :token, command.args.first)
  client.send_message(text: "Great! I got your token: #{command.args.first}", body: {})
end

Telegram::Commander.add_command(:info) do |client|
  stored_info = ''
  user = client.user

  if user.provider_info
    user.provider_info.keys.each do |credentials_key|
      stored_info += "#{credentials_key}\n"
      user.provider_info[credentials_key].each do |key, value|
        stored_info += "#{key}: #{value}\n"
      end
      stored_info += "\n"
    end
  end
  if user.task_manager_info
    user.task_manager_info.keys.each do |credentials_key|
      stored_info += "#{credentials_key}\n"
      user.task_manager_info[credentials_key].each do |key, value|
        stored_info += "#{key}: #{value}\n"
      end
      stored_info += "\n"
    end
  end
  if user.repository_info
    user.repository_info.keys.each do |credentials_key|
      stored_info += "#{credentials_key}\n"
      user.repository_info[credentials_key].each do |key, value|
        stored_info += "#{key}: #{value}\n"
      end
      stored_info += "\n"
    end
  end
  client.send_message(text: "This is your stored info:\n\n#{stored_info}", body: {})
end
