import Foundation

class BeaconCircle: Circle {
    private (set) var correctedDistance: Double
    let minor: Int
    private (set) var notCorrectedDistance: Double
    var correctDistanceForText: Double
    var notCorrectDistanceForText: Double
    
    init(correctedDistance: Double, minor: Int, notCorrectedDistance: Double, correctDistanceForText: Double, notCorrectDistanceForText: Double, x: Int, y: Int) {
        self.correctedDistance = correctedDistance
        self.minor = minor
        self.notCorrectedDistance = notCorrectedDistance
        self.correctDistanceForText = correctDistanceForText
        self.notCorrectDistanceForText = notCorrectDistanceForText
        super.init(x: x, y: y)
    }
}
