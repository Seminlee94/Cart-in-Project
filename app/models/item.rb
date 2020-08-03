class Item < ActiveRecord::Base
    has_many :customeritems
    has_many :customers, through: :customeritems
    has_many :carts, through: :customers
end