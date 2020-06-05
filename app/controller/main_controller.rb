class MainController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    enable :sessions
    set :session_secret, SecureRandom.hex(64)
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
        session[:user_id] = @user.id
        sesh_id = session[:user_id] 
        redirect "/dynamic/#{sesh_id}/welcome"
    end

    post '/loginauth' do
        @user = Employee.find_by(username: params[:username], password: params[:password])

        if @user 
            @session = session
            sesh_id = @session[:session_id] 
            redirect "/dynamic/#{@user.id}/#{sesh_id}/welcome"
        else
            erb :'registration/signup'
        end 
    end

    get '/dynamic/:id/:sesh_id/welcome' do
        @user = Employee.find_by(id: params[:id])
        erb :'employee/main_pg_employees'
    end

    get '/dynamic/:id/all_tics' do
        @user = Employee.find_by(id: params[:id])
        erb :'ticket/main_pg_tickets'
    end 

    get '/logout' do
        session.clear 
        redirect "/"
    end 

    get '/hey' do 
        @session = session
        @user = Employee.find_by(id: params[:id])
        binding.pry
    end 

end 
