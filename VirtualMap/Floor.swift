import Foundation

class Floor {
    private(set) var walls: [Wall]
    private(set) var doors: [Door]
    private(set) var beacons: [Beacon]
    private(set) var isneedreview: Bool?
    
    init(walls: [Wall], doors: [Door], beacons: [Beacon], isneedreview: Bool) {
        self.walls = walls
        self.doors = doors
        self.beacons = beacons
        self.isneedreview = isneedreview
    }
}
