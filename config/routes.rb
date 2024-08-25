Rails.application.routes.draw do
  get 'todo_item/index'
  get 'todo_item/create'
  get 'todo_item/show'
  namespace :api do
    resources :todo_lists, only: %i[index create update show destroy], path: :todolists do
      resources :todo_items, only: %i[index create update show destroy], path: :todoitems
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
