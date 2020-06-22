require './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

# allows us to use PATCH and DELETE routes
use Rack::MethodOverride

#auto adds controllers
# Dir[File.join(File.dirname(__FILE__), "app/controllers", "*.rb")].collect {|file| File.basename(file).split(".")[0] }.reject {|file| file == "main_controller" }.each do |file|
#   string_class_name = file.split('_').collect { |w| w.capitalize }.join
#   class_name = Object.const_get(string_class_name)
#   use class_name
# end

#use CrudController
run MainController