class WebhookProviderController < ApplicationController
  def index

    client = "#{params[:provider]}_service".camelcase.constantize.send(:new, nil) 

    puts 'params --------'
    puts params.keys
    puts 'chat ----'
    puts params[:message]['chat']


    body = {chat_id: params[:message]['chat']['id']}
    client.send_message(text: "hello #{params[:message]['from']['first_name']}", body: body)

    head :ok
  end
end
