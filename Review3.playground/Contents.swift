import UIKit

// Polymorphism and typecasting

class Album {
    var name: String

    init(name: String) {
        self.name = name
    }

    func getPerformance() -> String {
        return "The album \(name) sold lots"
    }
}

class StudioAlbum: Album {
    var studio: String

    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }

    override func getPerformance() -> String {
        return "The studio album \(name) sold lots"
    }
}

class LiveAlbum: Album {
    var location: String

    init(name: String, location: String) {
        self.location = location
        super.init(name: name)
    }

    override func getPerformance() -> String {
        return "The live album \(name) sold lots"
    }
}

var taylorSwift = StudioAlbum(name: "Taylor Swift", studio: "The Castles Studios")
var fearless = StudioAlbum(name: "Speak Now", studio: "Aimeeland Studio")
var iTunesLive = LiveAlbum(name: "iTunes Live from SoHo", location: "New York")

var allAlbums: [Album] = [taylorSwift, fearless, iTunesLive]

for album in allAlbums {
    print(album.getPerformance())
}

for album in allAlbums {
    print(album.getPerformance())

    if let studioAlbum = album as? StudioAlbum {
        print(studioAlbum.studio)
    } else if let liveAlbum = album as? LiveAlbum {
        print(liveAlbum.location)
    }
}

for album in allAlbums {
    let studioAlbum = album as! StudioAlbum
    print(studioAlbum.studio)
}

// Force unwrapping album as an array of StudioAlbum, which can fail
for album in allAlbums as! [StudioAlbum] {
    print(album.studio)
}

for album in allAlbums as? [LiveAlbum] ?? [LiveAlbum]() {
    print(album.location)
}

// Closures

let vw = UIView()

UIView.animate(withDuration: 0.5, animations: {
    vw.alpha = 0
})

// Trailing closures
UIView.animate(withDuration: 0.5) {
    vw.alpha = 0
}
