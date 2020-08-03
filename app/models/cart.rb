class Cart < ActiveRecord::Base
    has_many :customers
    has_many :items, through: :customers

    def cart_availability
        if self.customers.count < 4
            3 - self.customers.count
        end
    end

    def increment_cart_number
        last_cart = 0
        last_cart = Cart.all.select {|cart| cart.cart_number}.map(&:cart_number).last
        self.cart_number = last_cart + 1
        self.save
    end

end



# puts "Enter 2 to see the total amount."
# puts "Enter 3 to see the amount of an item."
# puts "Enter 4 to go back to your shopping cart."
# puts "Enter 5 to view your account information."

# when "2"
# def item_price
#     self.shopping_cart.map do |item|
#         item[:price]
#     end.inject(0) {|item, i| item + i }
# end
    #  puts "Would you like to check out? (y/n)"
    #  check_out = gets.chomp
    #  if check_out = "y"
# when "3"
#     puts "what item are you looking for?"
#     item_name = gets.chomp
#     shopping_cart.find do |cart|
#         cart[:item] == item_name
#     end
# when "4"
#     shopping_cart.map do |item|
#         item
#     end 