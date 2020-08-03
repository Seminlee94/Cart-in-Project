class Friend < ActiveRecord::Base
    belongs_to :customer
    has_one :cart, through: :customer

end