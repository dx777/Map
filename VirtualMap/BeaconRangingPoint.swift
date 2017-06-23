import Foundation

class BeaconRangingPoint: BeaconRangingData {
    private(set) var x : Int
    private(set) var y: Int
    private(set) var height: Int
    var currentRangingDistance: Double = 0 // distance, которое получено после ranging
    
    var allDistances: [Double] = [] // тут на последнем месте нескорректированное по калману значение, но скорректированное по высоте и сторонам треугольника
    var isActive: Bool = false
    var previousDistanceCorrectedByKalman: Double = 0 //тут скорректированное по калману значение.
    var isClosest: Bool = false
    //var notCorrectedDistance: Double = 0// previousDistance //тут скорректированное по калману значение.
    
    init (x: Int, y: Int, height: Int, uuid: UUID, major: Int, minor: Int, distance: Double) {
        self.x = x
        self.y = y
        self.height = height
        super.init(uuid: uuid, major: major, minor: minor, distance: distance)
        //self.notCorrectedDistance = distance
           }
}
