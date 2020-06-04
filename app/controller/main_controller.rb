class MainController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    enable :sessions
    set :session_secret, "my_application_secret"
    set :views, Proc.new { File.join(root, "../views/") }

    get '/' do
        erb :'main_page'
    end

    get '/login' do 
        erb :'session/login'
    end

    get '/signup' do
        erb :'registration/signup'
    end

    post '/registration' do
        @user = Employee.create(username: params[:username], password: params[:password])
        redirect "/dynamic/#{@user.id}/welcome"
    end

    post '/loginauth' do
        @user = Employee.find_by(username: params[:username], password: params[:password])
        
        if @user 
            #erb :'employee/main_pg_employees'
            redirect "/dynamic/#{@user.id}/welcome"
        else
            erb :'registration/signup'
        end 
    end

    get '/dynamic/:id/welcome' do
        @user = Employee.find_by(id: params[:id])
        erb :'employee/main_pg_employees'
    end

    get '/logout' do 
        redirect "/"
    end 

    get '/hey' do 
        @session = session
        "#{@session}"
    end 

end 