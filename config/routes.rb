Rails.application.routes.draw do
  # devise_for :users

  # resources :articles
  get '/articles', to: 'articles#index'

  namespace :v1 do
    get '/contacts/search', to: 'contacts#search', as: 'search'
    get '/categories/:id/products', to: 'categories#product_search'
    resources :categories
    resources :products
    resources :contacts
    
    resources :sessions, only: [:create, :destroy]


  end
  
end
