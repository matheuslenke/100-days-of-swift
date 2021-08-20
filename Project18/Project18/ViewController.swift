//
//  ViewController.swift
//  Project18
//
//  Created by Matheus Lenke on 20/08/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I'm inside the viewDidLoad() method.")
        print(1,2,3,4,5, separator: "-", terminator: "")
        
        // Using Assert
        // Doesn't work on production mode
        
        assert(1 == 1, "Math failure!")
//        assert(1 == 2, "Math failure!")
        
//        assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }


}

