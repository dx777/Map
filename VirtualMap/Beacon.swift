import Foundation

class Beacon {
    private(set) var x: Int
    private(set) var y: Int
    private(set) var name: String
    private(set) var heightAboveTheFloor: Int
    private(set) var uuid: UUID
    private(set) var major: Int
    private(set) var minor: Int
    private(set) var id: String
    
    init(x: Int, y: Int, name: String, heightAboveTheFloor: Int, uuid: UUID, major:Int, minor: Int, id: String) {
        self.x = x
        self.y = y
        self.name = name
        self.heightAboveTheFloor = heightAboveTheFloor
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.id = id
    }
}
