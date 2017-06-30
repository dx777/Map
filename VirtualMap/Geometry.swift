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
    
    static func getAttachedCoordinates(x: Int, y: Int, x1: Int, x2: Int, y1: Int, y2: Int ) -> [Int] {
        var coords : [Int] = [0, 0]
        
        let L : Double = Double(Int(x1 - x2) * Int(x1 - x2) + Int(y1 - y2) * Int(y1 - y2))
        let PR : Double = Double(Int(x - x1) * Int(x2 - x1) + Int(y - y1) * Int(y2 - y1))
        
        var res : Bool = true
        
        var cf : Double = PR / L
        if(cf.isNaN) {
            return coords
        }
        if(cf < 0) {
            cf = 0
            res = false
        }
        if(cf > 1) {
            cf = 1
            res = false
        }
        
        let xres : Double = Double(x1) + cf * Double(x2 - x1)
        let yres : Double = Double(y1) + cf * Double(y2 - y1)
        
        if(res) {
            coords[0] = Int(xres)
            coords[1] = Int(yres)
            return coords
        } else {
            let p : CGPoint = CGPoint(x: x, y: y)
            let p1 : CGPoint = CGPoint(x: x1, y: y1)
            let p2 : CGPoint = CGPoint(x: x2, y: y2)
            
            let d1 = Geometry.distanceBetweenPoints(x1: Double(p.x), y1: Double(p.y), x2: Double(p1.x), y2: Double(p1.y))
            let d2 = Geometry.distanceBetweenPoints(x1: Double(p.x), y1: Double(p.y), x2: Double(p2.x), y2: Double(p2.y))
            if (d1 <= d2) {
                coords[0] = x1
                coords[1] = y1
                return coords
            } else {
                coords[0] = x2
                coords[1] = y2
                return coords
            }
        }
    }
    
    /* Distance from a point (p1) to line l1 l2 */
    static func distanceFromPoint(p: CGPoint, toLineSegment v: CGPoint, and w: CGPoint) -> Double {
        let pv_dx = p.x - v.x
        let pv_dy = p.y - v.y
        let wv_dx = w.x - v.x
        let wv_dy = w.y - v.y
        
        let dot = pv_dx * wv_dx + pv_dy * wv_dy
        let len_sq = wv_dx * wv_dx + wv_dy * wv_dy
        let param = dot / len_sq
        
        var int_x, int_y: CGFloat /* intersection of normal to vw that goes through p */
        
        if param < 0 || (v.x == w.x && v.y == w.y) {
            int_x = v.x
            int_y = v.y
        } else if param > 1 {
            int_x = w.x
            int_y = w.y
        } else {
            int_x = v.x + param * wv_dx
            int_y = v.y + param * wv_dy
        }
        
        /* Components of normal */
        let dx = p.x - int_x
        let dy = p.y - int_y
        
        return sqrt(Double(dx * dx + dy * dy))
    }
}
