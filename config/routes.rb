Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resources :applications, param: :token do
      resources :chats, param: :number do
        resources :messages do
          collection do
            get 'search'
          end
        end
      end
    end
  end
end
