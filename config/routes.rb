Rails.application.routes.draw do
  resources :artifacts
  resources :tenants do
    resources :projects
  end
  resources :members
  get 'home/index'
  root :to => "home#index"
    
  # *MUST* come *BEFORE* devise's definitions (below)
  # this is going to milia confirmations update we want this to simply go to confirmations update
  as :user do   
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  devise_for :users, :controllers => { 
    :registrations => "milia/registrations",
    # update also this line of code
    :confirmations => "confirmations",
    :sessions => "milia/sessions", 
    :passwords => "milia/passwords", 
  }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
