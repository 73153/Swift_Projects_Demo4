//  Created by sachindra pandey on 10/06/14.
/*
Copyright (c) 2014 threeroots. All rights reserved.

This project has been created for the sole purpose
of serving as a tutorial, and a demo for those interested in learning 'Swift' programming language.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY 'threeroots' `AS IS' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
EVENT SHALL 'threeroots' OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/


/******* Lesson 1: Working with variables **********/

import UIKit

//example1: working with strings
var str = "The greatest song of all time"
var duration = 4.56
var launchYear = 1971
var nameString1 = "Led"
var nameString2 = "Zepplin"
var songName = "Black Dog"


var songDescription = "\(str) -- \(songName) (\(nameString1+nameString2)) Year: \(launchYear) duration:\(duration)"
println(songDescription)


//var songDescription2 = "\(str)" + " --" + " \(songName)" + "(\(nameString1+nameString2))" + " Year: \(launchYear)";

//example2: Calculations
/**
var radius:Float=12.3
var π = 3.14159265359
var area1 = (radius * radius) * Float(π) //implicitely converting Pi from double to float
var area2 = (Int(radius) * Int(radius)) * Int(π) //implicitely converting variables to int
// var area = (radius * radius) * (π) error: values are not implicitly converted
//var aString = "width is" + radius      error: values are not implicitly converted
var aString = "width is" + String(radius)  //explicitly converting float to string
var bString = "width is" + "\(radius)"     //explicitly converting float to string
*/

//Working with arrays and dictionary
/*
var metalBandsArray = [];  //empty array of generic type
var anArrayOfMetalGods = String[](); //empty array of strings
var avengersArray = ["Thor","Black widow","Captain America","Hulk"] //predefined array

//replacing objects at index
avengersArray[0]="Loki"
println(avengersArray);
println(avengersArray[3]);

//adding objects
avengersArray+="Iron Man"
println(avengersArray);

//adding objects from array
avengersArray+=["Spiderman","Hawkeye"]
println(avengersArray);

//removing objects
avengersArray[0..1] = [];
println(avengersArray);

//replacing objects in range
avengersArray[1...5]=["Nick Fury"]
println(avengersArray);

//adding objects from array
//anArrayOfMetalGods[0] = "Metallica"   //gives an error
//anArrayOfMetalGods[1] = "Judas priests" //gives an error
//anArrayOfMetalGods[2] = "Iron maiden" //gives an error

//println(anArrayOfMetalGods);
*/


//Dictionaries (TO DO)





//Optionals (Needed whenever a variable can be tested for holding 'Nil' values)
/*
var player1 = "player1"
var player2: String = "player2"
var player3: String? = "player3"

/* Error: as we have not defined player1 and player2 as optionals
if(player1){
println("player1 is present")
}
if(player2){
println("player2 is present")
}
*/

player3=nil
if(player3){
    println("player3 is present")
}
else{
    println("player3 is Nil")
}
*/

//Switch & For loops
/*
//switch with strings
let vegetable = "red pepper"
switch vegetable {
case "celery":
    let vegetableComment = "Add some raisins and make ants on a log."
case "cucumber", "watercress":
    let vegetableComment = "That would make a good tea sandwich."
case let x where x.hasSuffix("pepper"):
    let vegetableComment = "Is it a spicy \(x)?"
default:
    let vegetableComment = "Everything tastes good in soup."
}

//switch with generic data
let anObject = 1.5   //experiment with different values

switch anObject{
case "String":
    println("Its a string");
case 1.0...2.0:
    println("Its a float");
case 2:
    println("Its an Int");
default:
    println("Its a lost variable");
}
*/

//For Loop examples
/*
//example1: when quering a dictionary
let interestingNumbers = ["prime":[2,3,5,7,11,13],
                          "fibo":[1,1,2,3,5,8],
                          100:[10,10,"Harley","Quinn"]];
for (key,values) in interestingNumbers{
    println("key=\(key) values=\(values)")
    
}

//example2: when quering an array
let aMixArray  = [3,5,7,11,13,"Harley","Quinn",7.0];
for elements : AnyObject in aMixArray{
    println("elements=\(elements)")
}

//example3: normal for loop
for(var i=0; i<3 ;i++){
    println("\(aMixArray[i])");
}

for i in 5...7{
    println("\(aMixArray[i])");
}

*/

//Functions
/*
//example1
func sumFunction(a: Int , b: Int) ->Int{
    return a+b;
}
println("sum = \(sumFunction(2,3))")
var x=5
var y=3
println("sum = \(sumFunction(x,y))")

//example2
func sumAndMultiplicationFunction(var a: Float ,var  b: Float) ->(String,Double,Double){
    return ("Sum and Multiplication is:",Double(a) + Double(b),Double(a)*Double(b));
}

var opArray = sumAndMultiplicationFunction(5.0,6.0)

println("Function2 o/p = \(opArray)")

var anArray:NSArray?=["ek","do","teen"]
anArray.?count();
*/









