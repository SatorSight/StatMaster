Rails.application.routes.draw do
  get 'renew_data', to: 'main#renew_data'
  get 'commits_data', to: 'main#commits_data'
  get 'csv_data', to: 'main#csv_data'
  get 'metrics_data', to: 'main#metrics_data'
  get 'ya', to: 'main#metrika_test_data'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
end