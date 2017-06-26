import Foundation

class Floor {
    private(set) var walls: [Wall]
    private(set) var doors: [Door]
    private(set) var beacons: [Beacon]
    private(set) var elevators: [Elevator]
    private(set) var travolators: [Travolator]
    private(set) var stairs: [Stairs]
    private(set) var stacks: [Stack]
    private(set) var isneedreview: Bool?
    
    init(walls: [Wall], doors: [Door], beacons: [Beacon], elevators: [Elevator], travolators: [Travolator], stairs: [Stairs], stacks: [Stack], isneedreview: Bool) {
        self.walls = walls
        self.doors = doors
        self.beacons = beacons
        self.elevators = elevators
        self.travolators = travolators
        self.stairs = stairs
        self.stacks = stacks
        self.isneedreview = isneedreview
    }
}
