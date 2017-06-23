import Foundation

class Door {
    private(set) var distanceStart: Int
    private(set) var distanceEnd: Int
    private(set) var owner: String
    private(set) var id: String
    
    init(distanceStart: Int, distanceEnd: Int, owner: String, id: String) {
        self.distanceStart = distanceStart
        self.distanceEnd = distanceEnd
        self.owner = owner
        self.id = id
    }
}
