import UIKit

class Dog {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
    func makeNoise() {
        print("Woof!")
    }
}

let poppy = Dog(name: "Poppy", breed: "Poodle")

class Poodle: Dog {
    init(name: String) {
        super.init(name: name, breed: "Poodle")
    }
    override func makeNoise() {
        print("Yip")
    }

}

// Overriding Methods

let poodle = Poodle(name: "Billy")
poodle.makeNoise()

// Final Classes

final class Dog2 {
    var name: String
    var breed: String

    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

// Copying objects
struct Singer {
    var name = "Taylor Swift"
}
var singer = Singer()
print(singer.name)
// Struct creates another copy, class creates another pointer
var singerCopy = singer
singerCopy.name = "Justin Bieber"
print(singer.name)

// Deinitializers

class Person {
    var name = "John Doe"

    init() {
        print("\(name) is alive!")
    }

    func printGreeting() {
        print("Hello, I'm \(name)")
    }
    deinit {
        print("\(name) is no more!")
    }
}

for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}

// Mutability
class Singer2 {
    let name = "Taylor Swift"
}

let taylor = Singer2()
//taylor.name = "Ed Sheeran"
print(taylor.name)
