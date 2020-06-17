class Employee < ActiveRecord::Base
    has_secure_password
    has_many :tickets 
    
    validates :username, presence: true

end