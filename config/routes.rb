Rails.application.routes.draw do
  get 'renew_data', to: 'main#renew_data'
  get 'commits_data', to: 'main#commits_data'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
end