class MainController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :session_secret, "my_application_secret"
    set :views, Proc.new { File.join(root, "../views/") }

    get '/' do
        erb :'main_page'
    end

    get '/login' do 
        erb :'sessions/login'
    end

    get '/signup' do
        erb :'registration/signup'
    end

    get '/welcome' do
        erb :'employee/main_pg_employees'
    end

    post '/registration' do
        redirect '/welcome'
    end

end 