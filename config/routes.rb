Rails.application.routes.draw do
  get 'renew_data', to: 'main#renew_data'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
end