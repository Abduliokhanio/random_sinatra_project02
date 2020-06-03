class MainController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :session_secret, "my_application_secret"
    set :views, Proc.new { File.join(root, "../views/") }

    get '/' do
        erb :'main_page'
    end

    get '/login' do 
        erb :'registration/login'
    end

    get '/signup' do
        erb :'session/signup'
    end
end 