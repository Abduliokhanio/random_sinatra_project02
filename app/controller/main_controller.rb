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
        @user[:sesh_id] = rand(1..100)
        @user.save
        redirect "/dynamic/#{@user.id}/#{@user[:sesh_id]}/welcome"
    end

    post '/loginauth' do
        @user = Employee.find_by(username: params[:username], password: params[:password])

        @session = session
        if @user #&& @user[:sesh_id] == nil
            @user[:sesh_id] = rand(1..100000000000)
            @user.save
            logout = "dynamic/#{@user.id}/logout"
            redirect "/dynamic/#{@user.id}/#{@user[:sesh_id]}/welcome"
        else
            erb :'registration/signup'
        end 
    end

    get '/dynamic/:id/:sesh_id/welcome' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id] )
        erb :'employee/main_pg_employees'
    end

    get '/dynamic/:id/all_tics' do
        @user = Employee.find_by(id: params[:id])
        erb :'ticket/main_pg_tickets'
    end 

    get '/dynamic/:id/:sesh_id/logout' do
        @user = Employee.find_by(id: params[:id])
        @user[:sesh_id] = nil
        @user.save
        redirect '/login'
    end 

end 
