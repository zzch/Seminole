Rails.application.routes.draw do
  mount API => '/'
  namespace :public do
    get :welcome, to: 'home#welcome', as: :welcome
  end
  namespace :admin do
    root 'dashboard#index'
    get :dashboard, to: 'dashboard#index', as: :dashboard
    resources :clubs do
      resources :operators
    end
    resources :operators
    resources :versions
    resource :profile do
      get :edit_password
      put :update_password
    end
    get :sign_in, to: 'sessions#new', as: :sign_in
    post :sign_in, to: 'sessions#create'
    get :sign_out, to: 'sessions#destroy', as: :sign_out
    get '*not_found', to: 'errors#error_404'
  end
  scope module: :op do
    root 'dashboard#index'
    get :dashboard, to: 'dashboard#index', as: :dashboard
    resources :members
    resources :memberships
    resources :tabs do
      resources :playing_items
      resources :provision_items
      collection do
        get :progressing
        get :finished
        get :cancelled
        post :member_set_up
        post :visitor_set_up
      end
      member do
        put :cancel
        put :checkout
      end
    end
    resources :playing_items do
      resources :balls
    end
    resources :balls
    resources :provision_items
    resources :vacancies do
      collection do
        get :bulk_new
        post :bulk_create
      end
      member do
        put :close
        put :open
      end
    end
    resources :cards
    resources :provision_categories
    resources :provisions do
      member do
        get :async_show
      end
    end
    resource :profile do
      get :edit_password
      put :update_password
    end
    get :sign_in, to: 'sessions#new', as: :sign_in
    post :sign_in, to: 'sessions#create'
    get :sign_out, to: 'sessions#destroy', as: :sign_out
  end
end