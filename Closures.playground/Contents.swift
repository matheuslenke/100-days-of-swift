import UIKit

let driving = {
    print("I'm driving in my car")
}

driving()

// Accepting parameters in a Closure

let driving2 = { (place: String) in
    print("I'm going to \(place) in my car")
}

driving2("Brazil")

// Returning Values

let drivingWithReturn = { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

let message = drivingWithReturn("London")
print(message)

// Returning with empty parameters

let payment = { () -> Bool in
    print("Paying an anonymous person…")
    return true
}

// Closures as parameters

func travel(action: () -> Void) {
    print("I'm getting ready to go.")
    action()
    print("I arrived!")
}

travel(action: driving)

// Trailing closures

// Calling travel function passing action directly as a closure
// That's possible because action is the last parameter of travel
travel {
    print("I'm driving my car")
}

func animate(duration: Double, animations: () -> Void) {
    print("Starting a \(duration) second animation…")
    animations()
}

animate(duration: 3, animations: {
    print("Fade out the image")
})
// Omiting the animations parameter make things cleaner
animate(duration: 3) {
    print("Fade out the image")
}

// Using closures as parameters when they accept parameters

func travel2(action: (String) -> Void) {
    print("I'm getting ready to go.")
    action("London")
    print("I arrived!")
}

travel2 { (place: String) in
    print("I'm going to \(place) in my car")
}

// Using closures as parameters when they return values

func travel3(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}

travel3 { (place: String) -> String in
    return "I'm going to \(place) in my car"
}

// When would you use closures with return values as parameters to a function?

func reduce(_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
    // start with a total equal to the first value
    var current = values[0]

    // loop over all the values in the array, counting from index 1 onwards
    for value in values[1...] {
        // call our closure with the current value and the array element, assigning its result to our current value
        current = closure(current, value)
    }

    // send back the final current value
    return current
}

let numbers = [10, 20, 30]

let sum = reduce(numbers) { (runningTotal: Int, next: Int) in
    runningTotal + next
}

print(sum)

let multiplied = reduce(numbers) { (runningTotal: Int, next: Int) in
    runningTotal * next
}

print(multiplied)

// We can also use direcly the + operator
let sum2 = reduce(numbers, using: +)


// Shorthand parameter names

func travel4(action: (String) -> String) {
    print("I'm getting ready to go.")
    let description = action("London")
    print(description)
    print("I arrived!")
}

travel4 {
    "I'm going to \($0) in my car"
}

// ADVANCED TOPICS


// Closures with multiple parameters

func travel5(action: (String, Int) -> String) {
    print("I'm getting ready to go.")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}

travel5 {
    "I'm going to \($0) at \($1) miles per hour."
}

// Returning closures from function

func travel() -> (String) -> Void {
    return {
        print("I'm going to \($0)")
    }
}

let result = travel()
result("London")

// A use case for this
func makeRandomGenerator() -> () -> Int {
    let function = { Int.random(in: 1...10) }
    return function
}

let generator = makeRandomGenerator()
let random1 = generator()
print(random1)

// Capturing values
func travel6() -> (String) -> Void {
    var counter = 1

    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}
let result2 = travel6()
result2("London")
result2("London")
result2("London")


// Making a random number generator that don't return the same number in sequence
func makeRandomNumberGenerator() -> () -> Int {
    var previousNumber = 0
    
    return {
        var newNumber: Int

        repeat {
            newNumber = Int.random(in: 1...3)
        } while newNumber == previousNumber

        previousNumber = newNumber
        return newNumber
    }
}

let generator2 = makeRandomNumberGenerator()

for _ in 1...10 {
    print(generator())
}
