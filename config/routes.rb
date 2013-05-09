Lanparty::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  root :to => 'pages#home'

	scope "(:locale)", :locale => /en|nl/ do

		resources :blog_posts do
			resources :blog_comments
		end

		resources :orders do
			resources :order_items do
				post "scan", :on => :collection
				post "add", :on => :collection
			end

			put "place", :on => :member
			put "pay", :on => :member
		end

		resources :store_item_classes

		resources :pricing_defaults

		resources :store_item_pricing_overrides

		resources :store_item_class_pricing_overrides

		resources :user_groups

		resources :logs

		get 'user/edit' => 'users#edit', :as => :edit_current_user

		get 'signup' => 'users#new', :as => :signup

		get 'logout' => 'sessions#destroy', :as => :logout

		get 'login' => 'sessions#new', :as => :login

		get 'info' => 'pages#info'
		get 'location' => 'pages#location'
		get 'faq' => 'pages#faq'
		get 'contact' => 'pages#contact', :as => :contact
		get 'signup_finished' => 'pages#signup_finished', :as => :signup_finished
		get 'darules' => 'pages#rules', :as => :rules
		get 'admin' => 'pages#admin', :as => :admin

		namespace 'util' do
			get 'soundtest' => 'soundtest#soundtest', :as => :soundtest
			get 'order_check' => 'order_check#order_check', :as => :order_check
		end

		resources :sessions

		resources :users do
			post :markpayed, :on => :collection
			get :soundtest, :on => :collection
		end

		resources :barcodes

		resources :store_items
	end

	get '/:locale' => 'pages#home', :as => :home
	# The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
