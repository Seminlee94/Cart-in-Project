require 'rest-client'
require 'json'
require 'pry'



Cart.delete_all
Customer.delete_all
Item.delete_all
Customeritem.delete_all

cart1 = Cart.create(cart_number: 1, name_of_store: "Costco")
cart2 = Cart.create(cart_number: 2, name_of_store: "BJs")
cart3 = Cart.create(cart_number: 3, name_of_store: "Sams's Club")
cart4 = Cart.create(cart_number: 4, name_of_store: "Costco")
cart5 = Cart.create(cart_number: 5, name_of_store: "BJs")
cart6 = Cart.create(cart_number: 6, name_of_store: "Sams's Club")

item1 = Item.create(item_type: "coke", price: 1.25)
item2 = Item.create(item_type: "pepsi", price: 1.25)
item3 = Item.create(item_type: "aaple", price: 3.50)
item4 = Item.create(item_type: "banana", price: 1.29)
item5 = Item.create(item_type: "peach", price: 1.59)
item6 = Item.create(item_type: "grape", price: 2.49)
item7 = Item.create(item_type: "onion", price: 3.50)
item8 = Item.create(item_type: "chicken", price: 8.46)
item9 = Item.create(item_type: "pork", price: 6.94)
item10 = Item.create(item_type: "shrimp", price: 9.21)

customer1 = Customer.create(log_in_id: "Sam", log_in_password: "abc", cart_id: cart4.id, name: "Sam")
customer2 = Customer.create(log_in_id: "Kate", log_in_password: "abc", cart_id: cart2.id, name: "Kate")
customer3 = Customer.create(log_in_id: "James", log_in_password: "abc", cart_id: cart4.id, name: "James")
customer4 = Customer.create(log_in_id: "Jack", log_in_password: "abc", cart_id: cart3.id, name: "Jack")
customer5 = Customer.create(log_in_id: "Mary", log_in_password: "abc", cart_id: cart1.id, name: "Mary")
customer6 = Customer.create(log_in_id: "Brian", log_in_password: "abc", cart_id: cart2.id)
customer7 = Customer.create(log_in_id: "Jack", log_in_password: "abc")
customer8 = Customer.create(log_in_id: "Jill", log_in_password: "abc", name: "Jill")
customer8 = Customer.create(log_in_id: "Jackie", log_in_password: "abc", name: "Jackie")

ci1 = Customeritem.create(item_id: item1.id, customer_id: customer1.id)
ci2 = Customeritem.create(item_id: item2.id, customer_id: customer1.id)
ci3 = Customeritem.create(item_id: item3.id, customer_id: customer1.id)
ci4 = Customeritem.create(item_id: item4.id, customer_id: customer1.id)
ci5 = Customeritem.create(item_id: item5.id, customer_id: customer1.id)
ci6 = Customeritem.create(item_id: item1.id, customer_id: customer3.id)
ci7 = Customeritem.create(item_id: item3.id, customer_id: customer3.id)
ci8 = Customeritem.create(item_id: item10.id, customer_id: customer4.id)
ci9 = Customeritem.create(item_id: item9.id, customer_id: customer4.id)
ci10 = Customeritem.create(item_id: item8.id, customer_id: customer4.id)
ci11 = Customeritem.create(item_id: item7.id, customer_id: customer2.id)
ci12 = Customeritem.create(item_id: item6.id, customer_id: customer2.id)
ci13 = Customeritem.create(item_id: item8.id, customer_id: customer2.id)
ci14 = Customeritem.create(item_id: item7.id, customer_id: customer6.id)
ci15 = Customeritem.create(item_id: item2.id, customer_id: customer6.id)
