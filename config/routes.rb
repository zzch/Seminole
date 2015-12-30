Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
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
    resources :users do
      collection do
        get :initial
        get :async_uniqueness_check
      end
    end
    resources :members do
      resources :memberships
    end
    resources :memberships
    get :search, to: 'search#create', as: :search
    resources :tabs do
      resources :playing_items
      resources :provision_items
      resources :extra_items
      collection do
        get :progressing
        get :finished
        get :cancelled
        post :member_set_up
        post :visitor_set_up
      end
      member do
        put :cancel
        get :checkout
        get :print
        put :checking
      end
    end
    resources :playing_items do
      resources :balls
      member do
        put :finish
        patch :payment_method
        get :edit_started_at
        patch :update_started_at
        get :edit_finished_at
        patch :update_finished_at
      end
    end
    resources :balls
    resources :provision_items do
      member do
        patch :payment_method
      end
    end
    resources :extra_items do
      member do
        patch :payment_method
      end
    end
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
    resources :cards do
      resources :vacancy_prices do
        collection do
          get :bulk_new
          post :bulk_create
        end
      end
    end
    resources :vacancy_prices
    resources :provision_categories
    resources :provisions do
      member do
        get :async_show
      end
    end
    resources :reservations
    resources :announcements
    resources :coaches do
      resources :courses
    end
    resources :courses do
      resources :lessons
    end
    resources :lessons
    resources :students
    resources :salesmen
    resources :feedbacks
    resources :preferences
    resource :profile do
      get :edit_password
      put :update_password
    end
    get :sign_in, to: 'sessions#new', as: :sign_in
    post :sign_in, to: 'sessions#create'
    get :sign_out, to: 'sessions#destroy', as: :sign_out
  end
  namespace :social do
    resources :vouchers
  end
end