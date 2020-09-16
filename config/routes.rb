Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'work_logs#index'

  resources :work_logs do
    collection do
      get :export_csv, format: :csv
    end
  end
end
