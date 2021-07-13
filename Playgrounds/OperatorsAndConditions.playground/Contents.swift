import UIKit

let a = 2
let b = 3


let c = a + b



// Range operators

let score = 85

switch score {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did OK.")
case 85...:
    print("Nice!")
    fallthrough
case ...0:
    print("Its hard to be so bad")
    fallthrough
default:
    print("You did great!")
}
