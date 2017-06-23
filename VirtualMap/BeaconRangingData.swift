import Foundation

class BeaconRangingData {
    
    let uuid: UUID
    let major: Int
    let minor: Int
    var distance: Double 
    
    init(uuid:UUID, major: Int, minor: Int, distance: Double) {
        self.uuid = uuid
        self.major = major
        self.minor = minor
        self.distance = distance
    }
}
