Rails.application.routes.draw do
  namespace :communication do
    resources :communications, only: [:index,:new ,:create]
    resources :communication_details, only: [:new,:create]
     #conversation row click
     get "conversation_forum/:id", to: "communications#conversation_forum", as: "conversation_forum" 
  end
  get 'rails/g'
  get 'rails/controller'
  #For admin sing_in
  get 'bl-admin', as: "bl-admin", to:"admin/dashboard#admin"
   
   # commons Controller
   scope ':scop_name' do
    get "user_setting" ,to: "commons#user_setting"
    get "genuine_password" ,to: "commons#genuine_password"
   end
   patch "genuine_password_change/:confirmation_token" ,to: "commons#genuine_password_change" ,as: 'genuine_password_change'
   patch "user_setting_update" ,to: "commons#user_setting_update"
   get "get_region_name_by_prefecturename/:name", to: "commons#get_region_name_by_prefecturename"

  namespace :welcome do
    get 'welcomes/index', as: 'index'
    get 'student', as: 'student', to: "welcomes#student_index"
    get 'company', as: 'company', to: "welcomes#company_index"
    get 'contact', as: "contact", to:"welcomes#contact_index"
    get 'privacy', as: "privacy", to:"welcomes#privacy_index"
    get 'term_condition', as: "term_condition", to:"welcomes#term_condition_index"
    get 'registration_complete', as: "registration_complete", to:"welcomes#registration_complete"
    post 'contact_create', as: "contact_create", to:"welcomes#contact_create"
    get 'student_login', as: "student_login", to:"welcomes#student_login"
    get 'student_register', as: "student_register", to:"welcomes#student_register"
    get 'company_login', as: "company_login", to:"welcomes#company_login"
    get 'company_register', as: "company_register", to:"welcomes#company_register"
  end

  namespace :company do
    resources :companies, only: [:index,:edit,:update, :create,:show]
    resources :vacancies , only: [:index,:new,:edit,:update,:create,:show]
    resources :assessments, only: [:index,:update,:create]
    resources :events
    #Student Search and Detail
    get "students_search" , to: "search#student_search"
    get "student_details/:id", to: "search#student_details", as: "student_details"
    get "index", to: "search#index"
    get "favourite_student/:id", to: "search#favourite_student", as: "favourite_student" 
    get "getLocationDetails", to: "search#getLocationDetails"
    get "favourite_student_index", to: "companies#favourite_student_index"
    get "join_event_student_list/:id", to: "companies#join_event_student_list", as: "join_event_student_list"
    #set mail setting
    get "mail_settings/:mail_setting", to: "companies#mail_settings"
  end

  namespace :student do
    resources :students, only: [:index,:edit,:update,:create,:show]
    resources :assessments, only: [:index,:update,:create]
    get "student_smart_brain_diagnosis" , to: "assessments#student_smart_brain_diagnosis"
    get "student_potential_desire_type_diagnosis" , to: "assessments#student_potential_desire_type_diagnosis"
    get "student_behavioral_trait_type" , to: "assessments#student_behavioral_trait_type"
    #company Search and Detail
    get "companies_search" , to: "search#company_search"
    get "companies_detail/:id" , to: "search#company_detail"
    get "favourite_company/:id", to: "search#favourite_company"
    #Seach Vacancy and Detail
    get "vacancy_search" , to: "search#vacancy_search"
    get "favourite_vacancy/:id", to: "search#favourite_vacancy"
    #Search Event
    get "search_event", to: "search#search_event"
    get "search_event_detail/:id" , to: "search#search_event_detail", as: "event_details"
    get "favourite_event/:id", to: "search#favourite_event"
    get "join_event/:id", to: "search#join_event"

    get "prefecture_name/:id", to: "students#prefecture_name"
    get "favourite_company_index", to: "students#favourite_company_index"
    get "favourite_vacancy_index", to: "students#favourite_vacancy_index"
    get "favourite_event_index", to: "students#favourite_event_index"
    get "join_event_index", to: "students#join_event_index" 
  end

  devise_for :users, path: "users", controllers: { sessions: "users/sessions",passwords: "users/passwords", registrations: "users/registrations", confirmations: 'users/confirmations' }
  devise_scope :user do
    get "/logout", to: "users/sessions#destroy", as: :logout
    get "users", to: "welcome/welcomes#index"
  end

  devise_for :admins, path: "admins", controllers: { sessions: "admin/admins/sessions",passwords: "admin/admins/passwords"}
  devise_scope :admins do
    get "sign_in", to: "admin/admins/sessions#new"
    get "logout", to: "admin/admins/sessions#destroy"
  end

  namespace :admin do
    get 'dashboard/index'
    get 'password_change' , to: "commons#admin_password_change"
    post 'password_update' , to: "commons#password_update"
    get 'admin_student_setting', to: "student_manage/student#admin_student_setting"
    get 'admin_company_setting', to: "company_manage/company#admin_company_setting"
    get 'set_permission/:type_id/:user_id', to: "commons#set_permission"
    resources :backup_db

    namespace :student_manage do
      # Admin Student
      get 'student_search', to: 'student#student_search'
      get 'student_details', to: 'student#student_details'
      get 'student_edit', to: 'student#student_edit'
      get 'student_delete', to: 'student#student_delete'
      post 'student_update/:id', to: 'student#student_update'
      get 'admin_favourite_student', to: 'student#admin_favourite_student' 
    end
    namespace :company_manage do
      # Admin Company
      get 'company_search', to: 'company#company_search'
      get 'company_details', to: 'company#company_details'
      get 'company_edit', to: 'company#company_edit'
      post 'company_update/:id', to: 'company#company_update', as: "company_update"
      get 'company_delete', to: 'company#company_delete'
      get 'favourite_company', to: 'company#favourite_company'

      # Admin Event 
      get 'event_search', to: 'events#event_search'
      get 'event_details', to: 'events#event_details'
      get 'event_edit', to: 'events#event_edit'
      post 'event_update/:id', to: 'events#event_update', as: "event_update"
      get 'event_delete', to: 'events#event_delete'

      # Admin Vacancy
      get 'vacancy_search', to: 'vacancies#vacancy_search'
      get 'vacancy_details', to: 'vacancies#vacancy_details'
      get 'vacancy_edit', to: 'vacancies#vacancy_edit'
      post 'vacancy_update/:id', to: 'vacancies#vacancy_update', as: "vacancy_update"
      get 'vacancy_delete', to: 'vacancies#vacancy_delete'
    end
  end
 
  root to: 'welcome/welcomes#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
