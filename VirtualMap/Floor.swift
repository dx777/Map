import Foundation

class Floor {
    private(set) var walls: [Wall]
    private(set) var doors: [Door]
    private(set) var beacons: [Beacon]
    private(set) var elevators: [Elevator]
    private(set) var travolators: [Travolator]
    private(set) var isneedreview: Bool?
    
    init(walls: [Wall], doors: [Door], beacons: [Beacon], elevators: [Elevator], travolators: [Travolator], isneedreview: Bool) {
        self.walls = walls
        self.doors = doors
        self.beacons = beacons
        self.elevators = elevators
        self.travolators = travolators
        self.isneedreview = isneedreview
    }
}
