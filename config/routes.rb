Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'

  # routes for project resources
  resources :projects
  resources :taskflows
  resources :datasets
  resources :tasks
  resources :responses
  resources :surveys
  resources :survey_responses

  #routes for pages
  get '/start' => 'pages#start'
  get '/classify/:id' => 'pages#classify'
  get '/tutorial/i-am-sam' => 'pages#tutorial'
  get '/tutorial/visicount' => 'pages#visual_counter'

  #routes for users
  get '/profile/:id' => 'pages#profile'

end
