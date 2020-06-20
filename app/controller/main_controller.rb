class MainController < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    enable :sessions
    #set :session_secret, SecureRandom.hex(64)
    #set :session_secret, "secret"
    #set :session_secret, "secretsession"
    set :session_secret, "f650ed69344bab0084199bb8cc9aa5a1bd6756c3b57ad67023255af0fc3795057e"
    set :views, Proc.new { File.join(root, "../views/") }

    get '/' do
        erb :'session/login'
    end

    ## bs code start
    get '/bootstrap_test' do
        erb :'bootstrap_test'
    end

    get '/preloader' do
        erb :'preloader'
    end

    get '/sessions_set' do 
        session[:foo] = 'hello'
        if session[:foo] == 'hello'
            binding.pry
            redirect '/fetch'
          else
            "Session value has not been set!"
          end
    end 

    get '/fetch' do
        binding.pry
        "You did it! session[:foo] value: #{session[:foo]}.\nMove on to Part II of this lab at '/second_exercise' "
      end

    ## bs code end

    get '/signup' do
        erb :'registration/signup'
        
    end

    post '/registration' do
            @user = Employee.create(name: params[:name], username: params[:username], password: params[:password])
            @user[:sesh_id] = rand(1..100000000000)
            @user.save
            redirect "/dynamic/#{@user.id}/#{@user[:sesh_id]}/welcome"
    end

    post '/loginauth' do
        @user = Employee.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            @user[:sesh_id] = rand(1..100000000000)
            @user.save
            redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/welcome"
        else
            erb :'registration/signup'
        end 
    end

    post '/dynamic/:id/:sesh_id/create_ticket' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id] )
        if params[:title] != "" && params[:details] != ""  
            Ticket.create(title: params[:title], belongs_to: @user.username, details: params[:details], employee_id: @user.id)
            redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/welcome"
        else 
            redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/create_tickets"
        end
    end 

    post '/dynamic/:id/:sesh_id/update_ticket/:ticket_id' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id] )
        @ticket = Ticket.find_by(id: params[:ticket_id])
        @ticket.title = params[:title]
        @ticket.details = params[:details]
        @ticket.save
        redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/welcome"
    end

    get '/dynamic/:id/:sesh_id/welcome' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id] )
        erb :'employee/main_pg_employees'
    end

    get '/dynamic/:id/:sesh_id/logout' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id])
        @user[:sesh_id] = nil
        @user.save
        redirect '/'
    end 

    get '/dynamic/:id/:sesh_id/all_tickets' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id])
        @tickets = Ticket.all
        erb :'ticket/main_pg_tickets'
    end 

    get '/dynamic/:id/:sesh_id/create_tickets' do
        @user = Employee.find_by(id: params[:id])
        erb :'ticket/user_creates_ticket_for_self'
    end

    get '/dynamic/:id/:sesh_id/read_ticket/:ticket_id' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id])
        @ticket = Ticket.find_by(id: params[:ticket_id])
        erb :'ticket/read_ticket'
    end

    get '/dynamic/:id/:sesh_id/delete_ticket/:ticket_id' do
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id])
        @ticket = Ticket.find_by(id: params[:ticket_id])
        if @user.id == @ticket.employee_id
            Ticket.delete(params[:ticket_id].to_i)
            redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/welcome"
        else
            redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/welcome"
        end
    end

    get '/dynamic/:id/:sesh_id/update_ticket/:ticket_id' do 
        @user = Employee.find_by(id: params[:id], sesh_id: params[:sesh_id])
        @ticket = Ticket.find_by(id: params[:ticket_id])
        if @user.id == @ticket.employee_id
            erb :'ticket/update_ticket'
        else
            redirect "/dynamic/#{@user.id}/#{@user.sesh_id}/welcome"
        end
    end 


end 
