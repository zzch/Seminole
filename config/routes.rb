Rails.application.routes.draw do
  namespace :public do
    get 'welcome', to: 'home#welcome', as: :welcome
  end
  namespace :admin do
    root 'dashboard#index'
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :clubs do
      resources :operators
    end
    resources :operators
    resources :versions
    resource :profile do
      get 'edit_password'
      put 'update_password'
    end
    get 'sign_in', to: 'sessions#new', as: :sign_in
    post 'sign_in', to: 'sessions#create'
    get 'sign_out', to: 'sessions#destroy', as: :sign_out
    get '*not_found', to: 'errors#error_404'
  end
  scope module: :op do
    root 'dashboard#index'
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :members do
      collection do
        get :new_visitor
        get :new_regular
        post :create_visitor
        post :create_regular
      end
    end
    resources :tees do
      collection do
        get :bulk_new
        post :bulk_create
      end
      member do
        put :close
        put :open
      end
    end
    resource :profile do
      get 'edit_password'
      put 'update_password'
    end
    get 'sign_in', to: 'sessions#new', as: :sign_in
    post 'sign_in', to: 'sessions#create'
    get 'sign_out', to: 'sessions#destroy', as: :sign_out
    get '*not_found', to: 'errors#error_404'
  end
end