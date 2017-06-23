import Foundation
class Geometry {
    static func isPointInTriangle(a: CGPoint, b: CGPoint, c: CGPoint, userPoint: CGPoint) -> Bool {
        let b1: Bool = sign(firstPoint: userPoint, secondPoint: a, thirdPoint: b) < CGFloat(0.0)
        let b2: Bool = sign(firstPoint: userPoint, secondPoint: b, thirdPoint: c) < CGFloat(0.0)
        let b3: Bool = sign(firstPoint: userPoint, secondPoint: c, thirdPoint: a) < CGFloat(0.0)
        return ((b1 == b2) && (b2 == b3))
    }
    
    private static func sign(firstPoint: CGPoint, secondPoint: CGPoint, thirdPoint: CGPoint) -> CGFloat {
        return (firstPoint.x - thirdPoint.x) * (secondPoint.y - thirdPoint.y) - (secondPoint.x - thirdPoint.x) * (firstPoint.y - thirdPoint.y)
    }
    
    static func distanceBetweenPoints(x1: Double, y1: Double, x2:Double, y2: Double) -> Double {
        return sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2))
    }
}
