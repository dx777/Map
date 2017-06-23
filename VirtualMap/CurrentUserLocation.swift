import Foundation

class CurrentUserLocation {
    var isLocated: Bool
    var point: CGPoint? = nil
    var listPoints: [CGPoint] = []
    var previousPoint: CGPoint? = nil
    var abp: CGPoint? = nil
    var acp: CGPoint? = nil
    var pointForDrawPerpendiculars: CGPoint? = nil
    
    init() {
        self.isLocated = false
        self.point = nil
        self.previousPoint = nil
    }
}
