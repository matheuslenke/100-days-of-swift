import UIKit

struct Sport {
    var name: String
}

var tennis = Sport(name: "Tennis")
print(tennis.name)

tennis.name = "Lawn tennis"
print(tennis.name)

struct User {
    var name: String
    var age: Int
    var city: String
}
var tupleUser: (name: String, age: Int, city: String) = (name: "Name", age: 24, city: "Vix")
print(tupleUser)

// Property Observer

struct Progress {
    var task: String
    var amount: Int {
        didSet {
                  print("\(task) is now \(amount)% complete")
              }
    }
}

var progress = Progress(task: "Loading data", amount: 0)
progress.amount = 30
progress.amount = 80
progress.amount = 100

// Methods
struct City {
    var population: Int

    func collectTaxes() -> Int {
        return population * 1000
    }
}

let london = City(population: 9_000_000)
london.collectTaxes()

// Mutating Methods

struct Person {
    var name: String

    mutating func makeAnonymous() {
        name = "Anonymous"
    }
}

var person = Person(name: "Ed")
person.makeAnonymous()

// Properties and methods of strings
let string = "Do or do not, there is no try."

print(string.count)
print(string.hasPrefix("Do"))
print(string.uppercased())
print(string.sorted())
print("Testando".count)


// Properties and methods of arrays
var toys = ["Woody"]
print(toys.count)
toys.append("Buzz")
toys.firstIndex(of: "Buzz")
print(toys.sorted())
toys.remove(at: 0)

// To check if a string is empty, use this:
if myString.isEmpty {
    // code
}

// Not this:
if myString.count == 0 {
    // code
}
