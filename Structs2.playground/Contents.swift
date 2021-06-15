import UIKit

struct User {
    var username: String
    
    init() {
        username = "Anonymous"
        print("Creating a new user!")
    }
}

var user = User()
user.username = "twostraws"

// Maintaining meberwise initializer and custom initializer
struct Employee {
    var name: String
    var yearsActive = 0
}

extension Employee {
    init() {
        self.name = "Anonymous"
        print("Creating an anonymous employee…")
    }
}

// creating a named employee now works
let roslin = Employee(name: "Laura Roslin")

// as does creating an anonymous employee
let anon = Employee()

// Using Self
struct Person1 {
    var name: String

    init(name: String) {
        print("\(name) was born!")
        self.name = name
    }
}

// Lazy Properties

struct FamilyTree {
    init() {
        print("Creating family tree!")
    }
}

struct Person {
    var name: String
    lazy var familyTree = FamilyTree()

    init(name: String) {
        self.name = name
    }
}

var ed = Person(name: "Ed")
ed.familyTree
// Now that the property is accessed, then it creates the familyTree

// Static properties and methods

struct Student {
    static var classSize = 0
    var name: String
    
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}

let lenke = Student(name: "Lenke")
let taylor = Student(name: "Taylor")

print(Student.classSize)

struct Person2 {
    private var id: String

    init(id: String) {
        self.id = id
    }
    func identify() -> String {
        return "My social security number is \(id)"
    }
}

let ed2 = Person2(id: "12345")
ed2.identify()
