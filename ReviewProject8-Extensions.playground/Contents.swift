//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        
        view.addSubview(label)
        self.view = view
        label.bounceOut(duration: 10)
        
        // Challenge 2
        5.times() {
            print("Teste")
        }
        
        // Challenge 3
        let matheus = "Matheus"
        var names = [matheus, "Lenke", "Ryan", "Luis", matheus]
        names.remove(item: matheus)
        
        var numbers = [1, 2, 3, 4, 5, 1, 1]
        numbers.remove(item: 1)
        numbers.remove(item: 1)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

// Challenge 1

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

// Challenge 2

extension Int {
    func times(_ closure: () -> Void) {
        for _ in 0..<self {
            closure()
        }
    }
}

// Challenge 3

extension Array where Element:Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
                self.remove(at: index)
            
        }
    }
}

