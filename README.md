Project 2 Sinatra Project

Step 1) Gem install “corneal “ We are going to use the corneal gem because it sets up the file structure of the project for us. Not only that; it comes with nearly all the gems you need in your gem file. Next we’ll be making a couple a small updates and additions to the gemfile. Step X) Add to gemfile • Gem ‘shotgun’ o To allow us to test in real time • Gem ‘bcrypt’ o For securing & encrypting our passwords • Gem ‘rack-flash3’ o For getting out errors o Go ahead and add this to the environment.rb file • require 'rack-flash' o Update Activerecord to version 5.2.3 gem 'activerecord', '5.2.3', :require => 'active_record' Updating active record is just a personal preference. You can use the default active record that comes with the corneal gem. But when we get to migrations you need to remember to leave off the version number.

Step 2) Create the controllers Don’t forget make sure that the other controllers inherit from the main controller. Which in our case is called the “application_controller.rb” In the main controller we are going to store all our helpers. While you can make a separate helper file; for the sake of personal preference, we are going store our helpers in the “application_controller.rb”. It’ll look a little like this. You can add as many methods to it as you want into it.. helpers do def logged_in? !!session[:User_id] end end

• application_controller.rb(main) o Main controller holds the helpers. • employees_controller.rb o inherits from application_controller.rb o Handles the employee signup • login_controller.rb o inherits from application_controller.rb o Handles the routes related to logging in users • ticket_controller.rb o inherits from application_controller.rb o Handles all the routes related to CRUD Step 3) In config.ru make sure you are using and running the controllers properly. It’s best convention to “use” all the controllers except for the main controller (which we will “run”). use LoginController use EmployeesController use TicketController run ApplicationController And while we are here let’s go ahead and add our middleware because we are trying to implement CRUD functionality. Let’s add use Rack::MethodOverride so that we can access the “Patch”(aka “Update”) route and the “Delete” route # allows us to use PATCH and DELETE routes use Rack::MethodOverride

Step 4) Create the Models Make sure all models inherit from ActiveRecord::Base • employee.rb o Has many (tickets) (Which is provided by active record) o has_secure_password (Which is provided by bcrypt’) • class Employee < ActiveRecord::Base • has_many :tickets
• has_secure_password
• end

• ticket.rb o belongs to (employees) (Which is provided by active record) • class Ticket < ActiveRecord::Base • belongs_to :employee • end o

Step 5) Now that we have our models set up lets go ahead and create our tables and relationships • Lets create a migrate file in our db file. Sinatra wont work properly if this is not structured properly o db/migrate  Your tables are going to inherit from ActiveRecord::Migration[5.2]  Since we are using ActiveRecord::Migration[5.2] we have to specify  We are going to use the “change” method because it handles both “up & down” method functionalities  We need to use the active record “create_table” command on both tables to create the tables.  NOTICE how the tickets table has a foreign key. That is because it “belongs_to” the “Employee” • 01_create_employees_table.rb • class CreateEmployeesTable < ActiveRecord::Migration[5.2] • def change • create_table :employees do |t| • t.string :name • t.string :username • t.string :password_digest • end • end • end o • 02_create_tickets_table.rb • class CreateTicketsTable < ActiveRecord::Migration[5.2] • • def change • create_table :tickets do |t| • t.string :title • t.string :details • t.integer :employee_id •
• t.timestamps • end • end • end

Step 6) Lets run “rake db:migrate”. To actually build our database. Step 7) Lets go into the rake file and add the console task to help us test out relationships in the next step. • task :console do • Pry.start • End

Step 8) Lets run “rake console” And in the terminal lets create Employee objects and Ticket objects and make sure that they are both connected to each other by creating Employee objects & Ticket objects with respective foreign keys. [IMPORTANT it’s because of the foreign keys we are able to have the “Tickets belong to Employees” relationship] Relational Overview Ex: Employee.tickets -> list of Tickets Ex: Ticket.id.employee -> Name of employee Step 9) Create the Views Note ERB is similar to HTML. A good way to think of ERB is that it’s html that you can write ruby code in. So it allows you to use logic.
<%%> allows you to write ruby code <%=%> Allows you to display the output of your code. DON’T forget to set your vairables as instances in your route or else you wont be able to call them in the ERB files. There are endless ways you can have your views look. So it’s up to you. For the sake of brevity. Were going to focus on the back end logic. • sessions o login.erb • tickets o all_tickets.erb o create_ticket.erb o read_ticket.erb o update_ticket.erb • users o signup.erb • layout.erb o handles the layout for all the pages

Step 10) Now it’s time to create all our routes in our controller. For the sake of keeping this short. I’m going to link the github repo for those who want to follow along. I’m just going to write about the most mission critical routes and their functionality. The login route deals with the user’s ability to login. We do this by enabling sessions in the main route. And once the session is enabled we are able to persist and verify the session along routes. User’s can only user CRUD functionality if they are logged it. Other wise they are redirected.
get "/login" do @login_error = flash[:login_error] erb :'sessions/login' end

post '/login' do 
    employee = Employee.find_by(username: params[:username])
    if employee && employee.authenticate(params[:password])
        login_user(employee)
        redirect "/tickets"
    else 
        flash[:login_error] = "Please enter the correct username or password"
        redirect '/login'
    end 
end 
Now for the Crud Functionality

get "/tickets" do #Read -index action
    if logged_in?
        @tickets = current_user.tickets
        erb :'tickets/all_tickets'
    else
        redirect '/login'
    end 
end 
this route allows us to be able to see all the tickets(its the main page)

get "/tickets/new" do #Create -new action if logged_in? error_getter_ticket erb :'tickets/create_ticket' else redirect '/login' end end

post "/tickets" do #Create -create action
    if logged_in?
        ticket = current_user.tickets.build(params)
    
        if ticket.save
            redirect "/tickets"
        else
            error_setter_ticket(ticket)
            redirect  "/tickets/new"
        end 
    else
        redirect '/login'
    end
end
This route allows us to create tickets.

get "/tickets/:id" do #Read - show action if logged_in? @ticket = current_user.tickets.find_by(id: params[:id])

        if @ticket
            erb :'tickets/read_ticket'
        else
            redirect '/tickets'
        end
    else
        redirect '/login'
    end
end
This is another read route. It allows us to read more information about a particular ticket.

get "/tickets/:id/edit" do #Update -edit action if logged_in? error_getter_ticket @ticket = current_user.tickets.find_by(id: params[:id]) if @ticket erb :'tickets/update_ticket' else redirect '/tickets' end else redirect '/login' end end

patch "/tickets/:id" do #Update -update action
    #"Process the update and redirect"
    if logged_in?
        ticket = current_user.tickets.find_by(id: params[:id])
        if ticket
            if ticket.update(title: params[:title], details: params[:details])
                redirect "/tickets"
            else 
                error_setter_ticket(ticket)
                redirect "/tickets/#{params[:id]}/edit"
            end   
        else
            redirect '/tickets'
        end 
    else
        redirect '/login'
    end
end
This route handles the update functionality.

delete "/tickets/:id" do #Delete -delete action #"Delete and redirect" if logged_in? ticket = current_user.tickets.find_by(id: params[:id]) #replace delete with destroy if ticket Ticket.delete(ticket.id) redirect "/tickets" else redirect "/tickets" end else redirect '/login' end
end

This route handles the delete functionality.

The only reason we are able to use the last routes is due to the fact that we have the middle ware. Step 11) Lets add validations to make sure that the data being persisted is the data that we actually want • class Employee < ActiveRecord::Base • has_many :tickets
• has_secure_password
•
• #name • validates :name,:username,:password, presence: true • • #username • validates :username, uniqueness: true •
• end

• class Ticket < ActiveRecord::Base • belongs_to :employee • • #Ticket Title Validatiors • validates :title,:details, presence: true • validates :title, length: { in: 2..100 } • • #Ticket Detail Validators • validates :details, length: { in: 6..1000 } • • end

Step 12) Handling errors. Now that we have our app functional. We have to figure out how we are going to display the error messages. To let the user know that they aren’t putting in proper data. Lets add “use Rack::Flash” to the controllers we want to display our errors in. class EmployeesController < ApplicationController use Rack::Flash

… some routes and route logic end

“flash” functions similar to sessions. You can get the data to persist along routes through the “flash” hash. Once you try to edit or create data in your applications. If the data does pass the validations we set above. Active record will return an error along with specific information about the error. You can set to error message equal to a flash key of your choice and call the error in another route. Kind of like this. 
get "/login" do @login_error = flash[:login_error] erb :'sessions/login' end

post '/login' do 
    employee = Employee.find_by(username: params[:username])
    if employee && employee.authenticate(params[:password])
        login_user(employee)
        redirect "/tickets"
    else 
        flash[:login_error] = "Please enter the correct username or password"
        redirect '/login'
    end 
end 
And now that the error has been saved to an instance variable you can actually display it to the user.

Bonus Step 13) If you would like to make the application visually appealing. Use Bootstrap. It comes with a lot of coot tools and documentation on how to use the tools. Bonus Step 14) If you want to go over and beyond don’t forget to create the Styles Sheets Lets go ahead and abstract out the logic for our CSS & For the sake of keeping our code dry. Put your “main.css” file into the style sheet foulder.

• stylesheets o main.css
