Rails.application.routes.draw do
  resources :comments
  resources :uploads
  get 'users_list'=>'user#index'
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :tasks do
    member  do
      post 'assign_task'
    end
  end
  resources :meetings
  post 'login' =>'user#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
