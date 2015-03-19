// Playground - noun: a place where people can play
// Learn swift from http://tc-learnswift.herokuapp.com/problems?handle=llv22

import Foundation

// Challenge 21 – Super-Duper Shopping Cart (Use Xcode6-Beta6)

/**
R1 – Create a constant array of string literals called “types” with these
values: book, CD, software
**/
// implement code for R1 below
let types = ["book", "CD", "software"];


/**

R2 – Create a “Customer” struct with a “name” and “email” property
**/
// implement code for R2 below
struct Customer{
    
}


/**

R3 – Create a “randomCustomer” function that returns a tuple. Add 3

Customer structs to a dictionary using the customer’s name as the key.
This function returns a randomly selected name and email of a Customer
from the dictionary. (Hint: you can use arc4random_uniform to
randomly select a value.)
**/
// implement code for R3 below



/**

R4 – Create a “Product” class with the following properties:
1. id – Int
2. name – String
3. type – Constant, randomly selected value from “types” array
4. price – Double
5. discount – Double
6. saleStatus – String

Create an initializer that set’s the name, price and discount. The
discount should be set to 0 if discount is not passed. Set the
id to a random number between 1 and 10,000.

Create a getter for “saleStatus” that returns the String
“Sorry. This product is not on sale.” if dicsount is 0. Else
return the interpolated string “This product is on sale. It was
[display original price] but with a discount you only pay
[display sale price].”
**/
// implement code for R4 below



/**

R5 – Create an array called “products” with 5 product objects. Their names are
irrelevant but chose different prices. Set the discounts to 0, 0.1, 0.2, 0.3
and 0.4 respectively.

After adding the items to the array, iterate the collection and println the
“saleStatus” for each item.
**/
// implement code for R5 below



/**

R6 – Write a simple “Cart” class using Generics with the following properties:
1. customerName – String
2. customerEmail – String
3. items – any array of any type T
4. itemCount – Int, getter that returns the count of items in “items”.
5. promoCode – Optional String set to nil

Create an initializer that set the customerName and customerEmail.

Implement the following functions:

1. Create an “add” method that appends any type to the “items” array.
2. Create a “clear” method that removes all items from the “items” array.
3. Create a “remove” method that removes an item from the “items” array
based upon its position in the array.
4. Create a “getPromoCodeDisplay” method that returns the String “Your
promo code is [display promoCode].” if promoCode is not nil. Otherwise,
return the String “You do not have a promo code.”.
5. Create a “getCartStatus” method that returns the String “You have no
items in your cart.” if the number of items in the “items” array is 0.
Return the String “You have [display number of items] items in your
cart.” if the number of items in the “items” array is 1, 2 or 3.
For 4+ items in the “items” array, return the String “You are an
awesome customer!!”
**/
// implement code for R6 below



/**

R7 – Create a “customer” object by calling the “randomCustomer” function.
Create a new “cart” object for type Product with the newly created
“customer” object’s name and email. Printlnt customer’s name. Println the
itemCount (should be 0). Println the getCartStatus which should display
“You have no items in your cart.”
**/
// implement code for R7 below



/**

R8 – iterate the “products” array and add all items from the “products”
array to the cart except for element 3. Println the itemCount (should be 4),
println getStatus() (should display “You are an awesome customer!!”). Assign
the customer a promo code. First, println getPromoCodeDisplay (should
display “You do not have a promo code.”), then set the promoCode to “1234″,
then println the getPromoCodeDisplay again (should display “Your promo code
is 1234.”).
**/
// implement code for R8 below



/**
R9 – Remove the first item from the cart, then println the itemCount (should
be 3) and println the getCartStatus which should display “You have 3 items
in your cart.”
**/
// implement code for R9 below


