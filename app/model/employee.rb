class Employee < ActiveRecord::Base
    has_many :tickets
end