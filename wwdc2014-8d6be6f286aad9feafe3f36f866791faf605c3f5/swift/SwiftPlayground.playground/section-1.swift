// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

println(str)

for var l = 1; l < 10; l++
{
    println(l)
}

// see string of page 10 - 12 of the swift programming language
let label = "The width is";
let width = 94;
let widthlabel = label + String(width);

let apples = 3;
let oranges = 5;
let appleSummary = "I have \(apples) apples.";

// see array & dictionary of page 10 - 12 of the swift programming language
var shoppingList = ["catfish", "water", "tulips", "blue paint"];
shoppingList[1] = "bottle of water";
var occupations = [ "Malcolm" : "Caption", "Kaylee": "Mechanic"];
occupations["Jayne"] = "Public Relations";

let emptyArray = [String]();
let emptyDictionary = Dictionary<String, Float>();
shoppingList = [];
occupations = [:];

// see flow control of page 13 of the swift programming language
let individualScores = [75, 43, 103, 87, 12];
var teamScores = 0;
for score in individualScores{
    if score > 50{
        teamScores += 3;
    }
    else{
        teamScores += 1;
    }
}
teamScores;

// see string of page 15 of the swift programming language
var optionalString : String? = "Hello";
optionalString = nil;
var optionalName : String? = "JohnAppleseed";
var greeting = "Hello!";
if let name = optionalName {
    greeting = "Hello, \(name)";
//    greeting = "Hello, \(optionalName)";
}

// see string of page 17 of the swift programming language
let vegetable = "red pepper";
switch vegetable{
case "celery" :
    let vegetableComment = "Add some raisins and make ants on a log.";
case "cucumber", "watercress" :
    let vegetableComment = "That would make a good teas sandwich.";
case let x where ( x.hasPrefix("pepper") || x.hasSuffix("pepper") ):
    let vegetableComment = "Is it a spicy  \(x)?";
//case let x where x.hasSuffix("pepper") :
//    let vegetableComment = "Is it a spicy  \(x)?";
default:
    let vegetableComment = "Everything tastes good in soup.";
}

//see for-in iterater of page 19 of the swift programming language
let interestingNumbers = [
    "Prime" : [2, 3, 5, 7, 11, 13],
    "Fibonacci" : [1, 1, 2, 3, 5, 8],
    "Square" : [1, 4, 9, 16, 25]
];
var largest = 0;
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest{
            largest = number;
        }
    }
}
largest;

//see while of page 19 of the swift programming language
var n = 2;
while n < 100 {
    n *= 2;
}
n;

var m = 2;
do{
    m *= 2;
} while m < 100;
m;

var firstForLoop = 0;
for i in 0...3{
    firstForLoop += 1;
}
firstForLoop;

var secondForLoop = 0;
for var i = 0; i < 3; ++i{
    secondForLoop += 1;
}
secondForLoop;

var thirdForLoop = 0;
for i in 0..<4{
    thirdForLoop += 1;
}
thirdForLoop;

//see function of page 23 of the swift programming language
func greeting(name : String, day : String) -> String {
    return "Hello \(name), today is \(day)";
}
greeting("Bob", "Tuesday");

func getGasPrices() -> (Double, Double, Double){
    return (3.59, 3.69, 3.79);
}
getGasPrices();

func sumOf(numbers : Int...) -> Int{
    var sum = 0;
    for number in numbers{
        sum += number;
    }
    return sum;
}
sumOf();
sumOf(42, 597, 12);

func returnFifteen() -> Int {
    var y = 10;
    //inner func to add inner variable
    func add(){
        y += 5;
    }
    add();
    return y;
}
returnFifteen();

//see function and cloure of page 27 of the swift programming language
func makeIncrementer() -> (Int -> Int) {
    func addOne(number: Int) -> Int{
        return 1 + number;
    }
    return addOne;
}
var increment = makeIncrementer();
increment(7);

func hasAnyMatches(list : [Int], condition : Int -> Bool) -> Bool {
    for item in list{
        if condition(item) {
            return true;
        }
    }
    return false;
}
func lessThanTen(number : Int) -> Bool {
    return number < 10;
}
var numbers = [20, 19, 7, 12];
hasAnyMatches(numbers, lessThanTen);

//see - in for seperation of arguments
numbers.map({
    (number: Int) -> Int in
    let result = 3 * number;
        return result;
    });

//see - single parameter
let mappedNumbers = numbers.map({number in 3 * number});
mappedNumbers;
let sortedNumbers = sorted(numbers, { $0 > $1 });
sortedNumbers;
let sorted1Numbers = sorted(numbers) { $0 > $1 };
sorted1Numbers;

//see object of page 32 of the swift programming language
class NamedShape{
    var numberOfSides: Int = 0;
    var name: String?;
    
    init(name : String){
        self.name = name;
    }
    
    deinit{
        self.name = nil;
    }
    
    func simpleDescription() -> String{
        return "A shape with \(numberOfSides) sides.";
    }
}

var shape = NamedShape(name: "Orlando");
shape.numberOfSides = 7;
var shapeDescription = shape.simpleDescription();

class Square : NamedShape{
    var sideLength: Double;
    
    init(sideLength: Double, name: String){
        self.sideLength = sideLength;
        super.init(name: name);
        self.numberOfSides = 4;
    }
    
    func area() -> Double{
        return self.sideLength * self.sideLength;
    }
    
    override func simpleDescription() -> String{
        return "A square with sides of length \(sideLength).";
    }
}
let test = Square(sideLength: 5.2, name: "my test square");
test.area();
test.simpleDescription();

class EquilateralTriangle: NamedShape{
    var sideLength: Double = 0.0;
    
    init(sideLength: Double, name: String){
        self.sideLength = sideLength;
        super.init(name: name);
        self.numberOfSides = 3;
    }
    
    var perimeter: Double{
        get{
            return 3.0 * sideLength;
        }
        set (newValue) {
            sideLength = newValue / 3.0;
        }
    // see newValue: Double not available, it's incorrect
//        set (newValue: Double) {
//            sideLength = newValue / 3.0;
//        }
//        set{
//            sideLength = newValue / 3.0;
//        }
    }
    
    override func simpleDescription() -> String{
        return "An equilateral triangle with sides of length \(sideLength).";
    }
}
var triangle = EquilateralTriangle(sideLength: 3.1, name: "a triangle");
triangle.perimeter;
triangle.perimeter = 9.9;
triangle.sideLength;

class TriangleAndSquare{
    var triangle: EquilateralTriangle{
        willSet {
            square.sideLength = newValue.sideLength;
        }
    };
    
    var square: Square{
        willSet {
            triangle.sideLength = newValue.sideLength;
        }
    };
    
    init(size: Double, name: String){
        self.square = Square(sideLength: size, name: name);
        self.triangle = EquilateralTriangle(sideLength: size, name: name);
    }
}
var triangleAndSquare = TriangleAndSquare(size: 10, name: "another test shape");
triangleAndSquare.square.sideLength;
triangleAndSquare.triangle.sideLength;
triangleAndSquare.square = Square(sideLength: 50, name: "larger square");
triangleAndSquare.square.sideLength;
triangleAndSquare.triangle.sideLength;

class Counter{
    var count: Int = 0;
    func incrementBy(amount: Int, numberOfTimes times: Int){
        count += amount * times;
    }
}
var counter = Counter();
counter.incrementBy(2, numberOfTimes: 7);

let optionalSquare: Square? = Square(sideLength: 2.5, name: "optional square");
let sideLength = optionalSquare?.sideLength;

//see enum/struct of page 45 of the swift programming language
enum Rank: Int{
    case Ace = 1;
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten;
    case Jack, Queen, King;
    
    func simpleDescription() -> String{
        switch self{
        case .Ace:
            return "ace";
        case .Jack:
            return "jack";
        case .Queen:
            return "queen";
        case .King:
            return "king";
        default:
            return String(self.toRaw());
        }
    }
}
let ace = Rank.Ace;
let aceRawValue = ace.toRaw();
let twoRawValue = Rank.Two.toRaw();
let tenRawValue = Rank.Ten.toRaw();
if let convertedRank = Rank.fromRaw(3) {
    let threeDescription = convertedRank.simpleDescription();
}

enum Suit{
    case Spades, Hearts, Diamonds, Clubs;
    func simpleDescription() -> String{
        switch self{
        case .Spades:
            return "spades";
        case .Hearts:
            return "hearts";
        case .Diamonds:
            return "diamonds";
        case .Clubs:
            return "clubs";
        }
    }
}
let hearts = Suit.Hearts;
let heartsDescription = hearts.simpleDescription();
struct Card{
    var rank:Rank;
    var suit:Suit;
    func simpleDescription() -> String{
        return "The \(rank.simpleDescription()) of \(suit.simpleDescription())";
    }
}
let threeOfSpades = Card(rank: .Three, suit: .Spades);
let threeOfSpadesDescription = threeOfSpades.simpleDescription();

enum ServerResponse{
    case Result(String, String);
    case Error(String);
}

let success = ServerResponse.Result("6:00 am", "8:09 pm");
let failure = ServerResponse.Error("Out of cheese");

switch success{
case let .Result(sunrise, sunset):
    let serverResponse = "Sunrise is at \(sunrise) and Sunset is at \(sunset).";
case let .Error(error):
    let serverResponse = "Failure ... \(error).";
}

switch failure{
case let .Result(sunrise, sunset):
    let serverResponse = "Sunrise is at \(sunrise) and Sunset is at \(sunset).";
case let .Error(error):
    let serverResponse = "Failure ... \(error).";
}

//see protocol/extension of page 55 of the swift programming language
protocol ExampleProtocol{
    var simpleDescription: String{
        get
    };
    mutating func adjust();
}

class SimpleClass: ExampleProtocol{
    var simpleDescription: String = "A very simple class.";
    var anotherProperty: Int = 69105;
    
    func adjust() {
        simpleDescription += "Now 100% adjusted.";
    }
}
var a = SimpleClass();
a.adjust();
let aDescription = a.simpleDescription;

struct SimpleStructure: ExampleProtocol{
    var simpleDescription: String = "A very simple structure.";
    mutating func adjust(){
        simpleDescription += "(adjusted)";
    }
}
var b = SimpleStructure();
b.adjust();
let bDescription = b.simpleDescription;

extension Int: ExampleProtocol{
    var simpleDescription: String {
        return "The number \(self)";
    }
    mutating func adjust(){
        self += 42;
    }
}
7.simpleDescription;
/** immutable value of type "int" only has mutating members named "adjust"
7.adjust();
7.simpleDescription;
*/
let protocolValue: ExampleProtocol = a;
protocolValue.simpleDescription;

//see generic of page 60 of the swift programming language
func repeat<ItemType>(item: ItemType, times: Int) -> [ItemType]{
    var result = [ItemType]();
    for i in 0 ..< times{
//        result += item; // migration from DP4 to DP5
        result.append(item);
    }
    return result;
}
repeat("knock", 4);

enum OptionalValue<T>{
    case None;
    case Some(T);
}
var possibleInteger: OptionalValue<Int> = .None;
possibleInteger = .Some(100);

//migration from DP4 to DP5
//func anyCommonElements <T, U where T: Sequence, U: Sequence, T.GeneratorType.Element: Equatable, T.GeneratorType.Element == U.GeneratorType.Element >
func anyCommonElements <T, U where T: SequenceType, U: SequenceType, T.Generator.Element: Equatable, T.Generator.Element == U.Generator.Element >
    (lhs: T, rhs: U) -> Bool {
        for lhsItem in lhs {
            for rhsItem in rhs {
                if lhsItem == rhsItem {
                    return true;
                }
            }
        }
        return false;
}
anyCommonElements([1, 2, 3], [3]);

let stringArray = ["c", "b", "a"];
var sortedStrings = sorted(stringArray) {
    $0.uppercaseString < $1.uppercaseString
}
