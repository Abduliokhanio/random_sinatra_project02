class CreateEmployeesTable < ActiveRecord::Migration[5.2]
    def change 
        create_table :employees do |t|
            t.string :name
            t.string :username
            t.string :password
        end 
    end 
end 