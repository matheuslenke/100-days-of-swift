import UIKit

// Arrays

let john = "John Lennon"
let paul = "Paul McCartney"

let beatles = [john, paul]

// Sets

// Items aren’t stored in any order; they are stored in what is effectively a random order.
// No item can appear twice in a set; all items must be unique.

let colors = Set(["red", "green", "blue"])
print(colors)

// Tuples

var name = (first: "Taylor", last: "Swift")
name.0
name.first
name.last

// Dictionaries

let heights = [
    "Taylor Swift": 1.78,
    "Ed Sheeran": 1.73
]

print(heights["Taylor Swift"]!)


// Dictionary default values

let favoriteIceCream = [
    "Paul": "Chocolate",
    "Sophie": "Vanilla"
]

favoriteIceCream["Charlotte", default: "Unknown"]

// Creating empty collections

var teams = [String: String]()
var results = [Int]()

var words = Set<String>()
var numbers = Set<Int>()

var scores = Dictionary<String, Int>()
var results2 = Array<Int>()


// Enums

enum Result {
    case success
    case failure
}
Result.failure

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic:String)
    case singing(volume: Int)
}
// This enum create a talking and need to specify a topic
let talking = Activity.talking(topic: "football")
print(talking)

// Enum with raw values
enum Planet: Int {
    case mercury
    case venus
    case earth
    case mars
}

let earth = Planet(rawValue: 2)
