class Customer < ActiveRecord::Base
    belongs_to :cart
    has_many :customeritems
    has_many :items, through: :customeritems
    has_many :friends
       
    def self.start_cart
        prompt = TTY::Prompt.new
        choices = ["Sign Up", "Sign In"]
        answer = prompt.select("What would you like to do?", choices)
        case answer
        when "Sign Up"
            self.sign_up
        when "Sign In"
            id = prompt.ask("Enter username:", default: "Cannot be blank.")
            password = prompt.ask("Enter password:", default: "Cannot be blank.")
            find_customer = Customer.find_by(log_in_id: id, log_in_password: password)
            if find_customer == [] || find_customer == nil
                puts "That is invalid. Please try again."
                choices = ["Forget username?", "Forget password?", "Go Back"]
                answer = prompt.select("Did you...", choices)
                case answer
                when "Forget username?"
                    self.find_username
                when "Forget password?"
                    self.find_password
                when "Go Back"
                    start_cart
                end
            else
                puts "Welcome back, #{find_customer.name}!"
                find_customer.main_screen
            end
        end 
    end

    def main_screen
        prompt = TTY::Prompt.new
        choices = ["Go to Profile", "Start Shop", "Exit"]
        answer = prompt.select("What would you like to do?", choices)
        case answer
        when "Go to Profile"
            user_profile
        when "Start Shop"
            self.cart.start_shop
        when "Exit"
            "Thank you for using Cart In! Hope to see you soon!"
            exit!
        end
    end
    
    def self.find_username ## method to find username
        prompt = TTY::Prompt.new
        puts "Enter name associated with the account"
        customer_name = prompt.ask("Enter name:", default: "Cannot be blank.")
        puts "Enter address associated with the account"
        customer_address = prompt.ask("Enter address:", detault: "Cannot be blank.")
        find_customer = Customer.find_by(name: customer_name, address: customer_address)
        if find_customer == nil || find_customer == []
            prompt = TTY::Prompt.new
            answer = prompt.select("That is invalid. Would you like to try again?", %w(yes no))
            case answer
            when "yes"
                find_username
            when "no"
                self.start_cart
            end
        else 
            prompt = TTY::Prompt.new
            prompt.keypress("Your username is #{find_customer.log_in_id}. Press enter to Continue", keys: [:return])
            self.start_cart
        end
    end

    def self.find_password ## method to find password
        prompt = TTY::Prompt.new
        puts "Enter username associated with the account"
        id = prompt.ask("Enter username:", default: "Cannot be blank.")
        puts "Enter name associated with the account"
        customer_name = prompt.ask("Enter name:", default: "Cannot be blank.")
        puts "Enter address associated with the account"
        customer_address = prompt.ask("Enter address:", detault: "Cannot be blank.")
        find_customer = Customer.find_by(log_in_id: id, name: customer_name, address: customer_address)
        if find_customer == nil || find_customer == []
            prompt = TTY::Prompt.new
            answer = prompt.select("That is invalid. Would you like to try again?", %w(yes no))
            case answer
            when "yes"
                find_username
            when "no"
                self.start_cart
            end
        else 
            prompt = TTY::Prompt.new
            prompt.keypress("Your password is #{find_customer.log_in_password}. Press enter to Continue", keys: [:return])
            self.start_cart
        end
    end


    def self.sign_up
        prompt = TTY::Prompt.new
        id = prompt.ask("Enter username:", default: "Cannot be blank.")
        find_customer = Customer.find_by(log_in_id: id)
        if find_customer == [] || find_customer == nil
            prompt = TTY::Prompt.new
            password = prompt.ask("Enter password:", default: "Cannot be blank.")
            customer_name = prompt.ask("Enter name:", default: "Cannot be blank.")
            customer_address = prompt.ask("Enter address:", detault: "Cannot be blank.")
            Customer.create(log_in_id: id, log_in_password: password, name: customer_name, address: customer_address)
            puts "Complete!"
            start_cart
        else 
            puts "The username already exists. Please enter different username."
            prompt = TTY::Prompt.new
            choices = ["Enter different username", "Go Back"]
            answer = prompt.select("What would you like to do?", choices)
            case answer
            when "Enter different username"
                sign_up
            when "Go Back"
                start_cart
            end
        end
    end

    def user_profile
        prompt = TTY::Prompt.new
        choices = ["View My Info", "View My Payment Methods", "View My Previous Transaction", "View MY Friend List", "Go Back to Main Screen"]
        answer = prompt.select("What would you like to do?", choices)
        case answer
        when "View My Info"
            puts "Log-in ID: #{self.log_in_id}" 
            puts "Password: #{self.log_in_password}"
            puts "Name: #{self.name}"
            puts "address: #{self.address}"
            prompt = TTY::Prompt.new
            choices = ["Name", "Address", "Password", "Exit"]
            answer = prompt.select("Would you like to update your profile?", choices)
            case answer
            when "Name"
                puts "Name:"
                self.name = gets.chomp
            when "Address"
                puts "Address:"
                self.address = gets.chomp

            when "Password"
                prompt = TTY::Prompt.new
                password = prompt.mask("Password")
                self.log_in_password = password
            when "Exit"
                user_profile
            end
            self.save
            puts "Name: #{self.name}"
            puts "Address: #{self.address}"
            prompt.keypress("Press enter to continue", keys: [:return])
            user_profile
        when "View My Payment Methods"
            self.cards.reload
            if self.cards == []
                prompt = TTY::Prompt.new
                choices = ["Add new card", "Go Back"]
                answer = prompt.select("What would you like to do?", choices)
                case answer
                when "Add new card"
                    Card.new_card(self.id, self.name)
                when "Go Back"
                    self.user_profile
                end
            else
                prompt = TTY::Prompt.new
                puts "The card(s) saved in this account is(are) #{self.cards.map(&:bank_name)}."
                choices = ["Add New Card", "Delete a Card", "Go Back"]
                answer = prompt.select("What would you like to do?", choices)
                case answer
                when "Add New Card"
                    Card.new_card(self.id, self.name)
                when "Delete a Card"
                    self.delete_card
                when "Go Back"
                    self.user_profile
                end
            end
        when "View My Previous Transaction"
            self.transactions.reload
            if self.transactions.all == [] || self.transactions.all == nil
                puts "You haven't made any transactions yet!"
                prompt = TTY::Prompt.new
                prompt.keypress("Press enter to continue", keys: [:return])
                self.user_profile
            else
                prompt = TTY::Prompt.new
                choices = self.transactions.map(&:date)
                answer = prompt.select("Which transaction would you like to view?", choices)
                case answer
                when answer
                    self.transactions.reload
                    found_transaction = self.transactions[choices.index(answer)]
                    puts "#{found_transaction.title} item(s) were purchased on this day. The total was #{self.transactions[choices.index(answer)].total}"
                    prompt.keypress("Press enter to continue", keys: [:return])
                    self.user_profile
                end
            end
        when "View MY Friend List"
            add_friend
        end
    end

    def add_friend
        self.friends.reload
        binding.pry
        puts "You have #{self.friends.count} friends in your list."
        prompt = TTY::Prompt.new
        answer = prompt.select("Would you like to add a friend?", %w(yes no))
        case answer
        when "yes"
            prompt = TTY::Prompt.new
            puts "Please type in your friend's username and name to send invitation"
            friend_username = prompt.ask("Enter username:", default: "Cannot be blank.")
            friend_name = prompt.ask("Enter name:", default: "Cannot be blank.")
            friend_instance = Customer.find_by(log_in_id: friend_username, name: friend_name)
            if friend_instance == nil || friend_instance == []
                puts "We couldn't find your friend's ID. please try again."
            else 
                new_friend = Friend.create(log_in_id: friend_instance.log_in_id, name: friend_instance.name)
                self.friends << new_friend
                puts "You have added #{new_friend.log_in_id}(#{new_friend.name}) to your friend list."
            end
            add_friend
        when "no"
            prompt = TTY::Prompt.new
            choices = ["View my list", "Go Back"]
            answer = prompt.select("What would you like to do?", choices)
            case answer
            when "View my list"
                prompt = TTY::Prompt.new
                choices = friend_list.select{|i|i.name}
                answer = prompt.select("Your list:", choices)
                case answer
                when answer
                    puts "hi"
                    add_friend
                end
            when "Go Back"
                user_profile
            end
        end
    end

end





    #         case answer
    #             choices = ["Start Shopping", "Go to My Profile"]
    #     when "Start shopping"
    #         if self.cart == nil || self.cart == []
    #             puts "Which store would you like to shop at?"
    #             puts "Available shops are: Costco, BJs, and Sam's Club."
    #             store_name = gets.chomp.to_s
    #             binding.pry
    #             Cart.create(cart_number: self.cart)
    #         else
    #             puts "hi"
    #             binding.pry
    #         end
    #     when "Go to my profile"
    #     end
    # end
        # puts "1. Start shopping"
        # puts "2. Go to my profile"
    #     main_page = gets.chomp.to_i
    #     case main_page
    #     when 1
    #         if self.cart == nil
    #             puts "Which store would you like to shop at?"
    #             puts "Available shops are: Costco, BJs, and Sam's Club."
    #             store_name = gets.chomp.to_s
    #             if Cart.find_by(name_of_store: store_name) == nil
    #                 puts "That store is not available at this moment. Please choose another store."
    #             else 
    #                 new_cart = Cart.create(name_of_store: store_name)
    #                 new_cart.increment_cart_number
    #                 self.cart = new_cart
    #                 # binding.pry
    #                 self.start_shop
    #             end
    #         else
    #                 self.start_shop
    #         end
    #         self.save
    #     end
    # end
    #         when 2
    #             puts "Enter 1 to view your info"
    #             puts "Enter 2 to view your previous purchases"
    #             puts "Enter 3 to add a friend to your friend list"
    #             puts "Enter 4 to view your payment methods"
    #             puts "Enter 5 to go back" 
    #             puts "Enter 6 to exit"
    #             my_profile = gets.chomp.to_i
    #             case my_profile
    #             when 1
    #                 if self.name == nil || self.address == nil
    #                     puts "You need to save your name and address."
    #                     update_info
    #                 else
    #                     self.customer_info
    #                     update_info
    #                 end
    #             when 2
    #                 puts "previous purchases"
    #             when 3
    #                 add_friend
    #             when 4
    #                 puts "payment methods"
    #             when 5
    #                 self.start_cart
    #             when 6
    #                 exit!
    #             end
    #         end
            
    #     end
        
    #     # def customer_names
    #     #     self.cart.customers.flat_map {|customer|
    #     #     customer.name}
    #     # end
        
    # def customer_names
    #     Customer.all.select {|customer| 
    #     customer.cart_id == self.cart.customers[0].cart_id}.map {|customer|
    #     customer.name}
    # end
        


    # def customer_info
    #     puts "Name: #{self.name}"
    #     puts "Address: #{self.address}"
    # end
        
        
    # def self.find_customer(customer_instance)
    #     Customer.all.find {|customer| customer.name == customer_instance}
    # end
        
        
    # def update_info
    #     puts "Do you want to update your account info? (y/n)"
    #     update = gets.chomp
    #     case update
    #     when "y"
    #         self.customer_info
    #         if self.name == nil || self.address == nil
    #             puts "Type in your name"
    #             update_name = gets.chomp
    #             self.name = update_name
    #             puts "Type in your address"
    #             update_address = gets.chomp
    #             self.address = update_address 
    #             customer_info
    #                 # binding.pry
    #             puts "This is correct info? (y/n)"
    #             y_n = gets.chomp
    #             case y_n
    #             when "y"
    #                 self.save
    #                 self.start_cart
    #             when "n"
    #                 self.update_info
    #             end
    #         else
    #             puts "Please type in which info you want to update"
    #             update_info = gets.chomp.downcase
    #             case update_info.downcase
    #             when "name" 
    #                 puts "Type in your name"
    #                 update_name = gets.chomp
    #                 self.name = update_name
    #             when "address"
    #                 puts "Type in your address"
    #                 update_address = gets.chomp
    #                 self.address = update_address 
    #             end
    #             self.customer_info
    #             self.save
    #         end
    #         self.update_info
    #     when "n"
    #         self.start_cart
    #     end
    # end
        
        
    # def cart_owner(friend_instance)
    #     if self.cart.cart_availability > 0
    #         friend_instance.cart = self.cart
    #         friend_instance.save
    #         self.save
    #         # binding.pry
    #         puts "You have added #{friend_instance.name} into your cart."
    #         if self.cart.cart_availability > 0
    #             puts "You may add up to #{self.cart.cart_availability} person(people) on your cart."
    #             puts "Would you like to add more? (y/n)"
    #             add_more = gets.chomp
    #             case add_more
    #             when "y"
    #                 cart_owner(friend_instance)
    #             when "n"
    #                 start_cart
    #             end
    #         else
    #             puts "There is no available spots left in your cart."
    #             self.start_cart
    #         end
    #     else
    #         puts "There is no available spots left in your cart."
    #         self.start_cart
    #     end
    # end
    
    # def start_shop # line 30
    #     puts "What would you like to do?"
    #     puts "Enter 1 to view your cart"
    #     puts "Enter 2 to view your items"
    #     puts "Enter 3 to view your friends' items"
    #     puts "Enter 4 to add your friend to your cart"
    #     puts "Enter 5 to go back to main menu"
    #     shop1 = gets.chomp.to_i
    #     case shop1
    #     when 1
    #         puts "You and your friend have #{self.view_cart_item} in your cart. The total amount is #{self.view_cart_sum}."
    #         puts "Would you like to add items? (y/n)"
    #         start_shop
    #     when 2
    #         # binding.pry
    #         puts "You have #{view_customer_item} in your cart. Your total is #{view_customer_sum}."
    #         puts "Would you like to proceed to checkout? (y/n)"
    #         start_shop
    #     when 3
    #         binding.pry
    #         puts "Your friend #{friend_instance.name} have #{view_friend_item} in the cart. Your friends' total is #{view_friend_sum}"
    #         start_shop
    #     when 4
    #         if self.cart.customers.count < 4
    #             puts "You have #{self.customer_names} person(people) on your cart. You may add up to #{self.cart.cart_availability} person(people) on your cart."
    #             # binding.pry
    #             puts "Would you like to add your friend in your cart? (y/n)"
    #             add_friend = gets.chomp
    #             case add_friend
    #             when "y"
    #                 puts "Please type in your friend's name"
    #                 customer_instance = gets.chomp.to_s
    #                 friend_instance = Customer.find_by(name: customer_instance)
    #                 self.cart_owner(friend_instance)
    #                         # binding.pry
    #             when "n"
    #                 self.start_cart
    #             end
    #         else 
    #             puts "Total of 3 people can be in one cart."
    #         end
    #     when 5
    #         self.start_cart
    #     end
    # end

    # def view_cart_instance #shows customer cart's item instances
    #     self.cart.items.all.select {|item|
    # item.item_type}
    # end

    # def view_cart_item #shows customer cart's item_type
    #     view_cart_instance.flat_map(&:item_type)
    # end

    # def view_cart_price #shows customer cart's item prices
    #     view_cart_instance.flat_map(&:price)
    # end

    # def view_cart_sum #shows cart sum
    #     view_cart_price.sum
    # end

    # def view_customer_instance #shows customer's item instances
    #     self.items.select {|item|
    # item.item_type}
    # end

    # def view_customer_item #shows customer's item_type
    #     view_customer_instance.flat_map(&:item_type)
    # end
    
    # def view_customer_price #shows customer's item prices
    #     view_customer_instance.flat_map(&:price)
    # end

    # def view_customer_sum #shows customer's sum
    #     view_customer_price.sum
    # end

    # def view_friend_item_id #shows array of friends' item_id
    #     cart_items = self.cart.items.map(&:id)
    #     customer_items = self.items.map(&:id)

    #     customer_items.each do |customer_item_id|
    #         cart_items.delete_at cart_items.find_index(customer_item_id)
    #     end
    #     cart_items
    # end

    # def view_friend_item_instance #shows array of friends' item_instance
    #     view_friend_item_id.map do |i|
    #         Item.find(i)
    #     end
    # end

    # def view_friend_item #shows array of friends' item_type
    #     view_friend_item_instance.map(&:item_type)
    # end

    # def view_friend_price #shows array of friends' item_price
    #     view_friend_item_instance.map(&:price)
    # end

    # def view_friend_sum #shows total of friends' cart
    #     view_friend_price.sum
    # end
