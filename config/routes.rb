Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  match 'webhook_provider/:provider', to: 'webhook_provider#index', via: :all
end
