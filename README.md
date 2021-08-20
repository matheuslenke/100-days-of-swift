# 100-days-of-swift

### Logs

**Day 27:** Today i learned a little about Capture lists in swift, and undertood the difference between weak, unowned and strong references, what they mean and how to write safe code preventing crashed and memory leaks

**Day 28** Today i learned a little about comparing strings and checking if a word is real, is possible, or it's letters are contained in another word. I also learned that in Swift you cant compare 2 strings with the == operator, just like booleans and numbers

**Day 29** Today i made a challenge that made me fix the content i learned in the past 2 days. It was about dealing with strings, checking it's length, and presenting errors to the user. I also solve a bug that the app treated words in a case-sensitive way

**Day 30** Today i started learning about how to do Auto layout directly in code. I now know that i can create horizontal and vertical stacks using a String to represent my elements, like this: 
```swift
"V:|[label1]-[label2]-[label3]"
```
The - represents a 10pt spacing

**Day 32** Today i learned the difference between widthAnchor, heightAnchor, topAnchor, bottomAnchor, leftAnchor, rightAnchor, leadingAnchor, trailingAnchor, centerXAnchor, and centerYAnchor. TrailingAnchor and leadingAnchor will flip in right-to-left languages. I also learned that i can use multiples and adding constants to constraints based on my main View

**Day 33** Today i learned about the Codable protocol, which automatically can parse data from a JSON to Swift objects

**Day 34** Today i learned a little about how to use tabBars and how AppDelegate and SceneDelegate works

**Day 35** Today i learned how to filter info in an array, and how to resize tableViewCell to word wrap and look nicer when displaying data.

**Day 36** Today i learned how to make a view entirely from code, and i found it really hard at first. A little confusing, specially for someone who already saw how SwiftUI is and really liked it

**Day 37** Today i learned about dealing with a lot of buttons and appending text to a textLabel, and again loading content from a file but using more complex separators to get all data needed for the game

**Day 38** Today i made the chalenge to draw a gray line around a UIView, adjusting it width, and rounding it corners

**Day 39** Today i learned more about Grand Central Dispatch and de Quality of Service queues, the user Interactive with highest priority, User initiated , Utility queue, for long tasks that user doesn't need right now, and the background queue. There is the default queue, bet

**Day 40** Today it was a review day, and i could apply some things i learned about GCD in past projects

**Day 41** Today was a challenge and i've built a game from ground and it was really nice seeing i could use a lot of tools without looking back everytime. It isn't perfect but i'm happy that i was able to do it in 1 hour

**Day 42** Today i started learning about Collection View, and it's differences and similarities with TableView. It's really good to have so many tools already built-in in UIKit

**Day 43** Today i started learning about UIImagePicker and it's so easy to get images from users phone, and it even has a built-in crop image feature! Also learned more about Collection View and cells

**Day 44** Today i reviewed what i studied about CollectionView and UIImagePicker, and made some challenges. It was nice to revisit Project 1 and see that i could modify it with more confidence than in my first time

**Day 45** Today i learned about SpriteKit and starting creating a game. I've used the SKSpriteNode to create sprites and add it to screen with addChild. I also learned to add a physics body with SKPhyisicsBody

**Day 46** Today i learned more about SpriteKit and about colision between different objects, checking what to do depending on the object, add labels and detect if there is a label where the user is clicking, so it do a different code. And also, do something different based the coordinates of the touch location

**Day 47** Today i learned about SpriteKit Particles with SKEmitterNode, and also modified a fire particle. I also made a challenge and could understand better SpriteKit

**Day 48** Today i learned about how to store some data in disk with UserDefaults. it is mainly used to store small pieces of data like user preferences

**Day 49** Today i practiced more about UserDefaults, modifying some of my last projects to use it and have a better experience. I learned more about the difference between Codable and NSCoding, and how to convert JSON to load and save it with user defaults

**Day 50** Half of the Challenge done!! Today was a challenge and i needed to create a tableView showing a list of captions, and when selected, it shows a picture related to that caption. It was really good to understand better how present worked and how to make it prompt for user an AlertController and then an UIImagePicker

**Day 51** Today i watched two talks by Paul Hudson at different conferences, one talking about elements of functional programming in Swift and another about some subjects that new learners of Swift struggle. It was nice to review some concepts and learn a little more about things like map, flatMap and filter

**Day 52** Today i started project 13, creating an App to apply filter to pictures. It was most a wrap up and code that i already knew, but i learned a little about generating auto layout automatically and about Core Image concepts

**Day 53** Today i used CoreImage and applied some filters to pictures. I also used UIImageWriteToSavedPhotosAlbum to save the picture with filters

**Day 54** Today was the challenge to make my Photo filters app better, and i had a lot of difficulty trying to make something different with auto Layout and to know how to deal with Float and CGFloat, but i think it was good to struggle 2 days in this project because now i fell like i know how to solve more problems

**Day 55** Today i learned more about SpriteKit and how to animate penguins in a different game. It had a lot of randomness and i used asyncAfter to call functions after some delay indefinetly

**Day 56** Today was the first time i created my own particles and learned more about audio playing in SpriteKit. I think it is useful, but it has some bugs probably cause i didn't know exactly how to do properly all the animations, but it worked really good at the end

**Day 57** Today i learned more about animations with CoreAnimation, and how easy it is to make basic animations, with CoreAnimation handling everything between two states that i define. I can even reset the transformations using .identity

**Day 58** Today i applied CoreAnimations in past projects, and now i understand it a lot more. It makes animations without a lot of code and it's extremly powerful in personalization. I also used with ease-in ease-out and with spring animations

**Day 59** Today i made a challenge creating from scratch an App that loads a JSON file filled with countries info, and put it in a table view, presenting a detail view when you select it. It was good to review some concepts of loading from a file

**Day 60** Today i started using MapKit and understanding it protocols. I also created some annotations for Capitals, and created my own way of showing info in that annotations using Apple tools

**Day 61** Today i made a challenge of doing a webView showing after user clicking in an Annotation info button in map, and it was a really nice result and easy to do. I also played with different ways to show a Map

**Day 62** Today i started a new game in spriteKit, using Timers and physics to make it work

**Day 63** Today i made a challenge in this new project to make some adjustments, and i even made a restart label that was not needed, just because i felt it was missing it

**Day 64** Today i learned more about debugging, how to use assert, how to use breakpoints in xCode and how to view my views hierarchy when my app is running, so i can debug elements too

**Day 65** Today i applied what i learned in Day 64 in project 1 and project 5, using breakpoints, asserts and Exception breakpoints to debug forced errors in my apps