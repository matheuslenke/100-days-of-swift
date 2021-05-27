import UIKit

// Basic for loops
let count = 1...10

for number in count {
    print("Number is \(number)")
}

let albums = ["Red", "1989", "Reputation"]

for album in albums {
    print("\(album) is on Apple Music")
}

// Without needing a variable use _

print("Players gonna ")

for _ in 1...5 {
    print("play")
}

// While Loops

var number = 1

while number <= 20 {
    print(number)
    number += 1
}

// Repeat loops
// Swift version of do while
number = 1

repeat {
    print(number)
    number += 1
} while number <= 20

// Doesnt run
while false {
    print("This is false")
}

// Run once
repeat {
    print("This is false")
} while false

// Exiting loops
var countDown = 10

while countDown >= 0 {
    print(countDown)

       if countDown == 4 {
           print("I'm bored. Let's go now!")
           break
       }

       countDown -= 1
}

print("Blast off!")

// Exit multiple loops

outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print ("\(i) * \(j) is \(product)")
        
        if product == 50 {
                  print("It's a bullseye!")
                  break outerLoop
            
        }
    }
}

// Skipping items in loop - Continue
for i in 1...10 {
    if i % 2 == 1 {
        continue
    }

    print(i)
}

// Infinite loops
var counter = 0

while true {
    print(" ")
    counter += 1

    if counter == 273 {
        break
    }
}
