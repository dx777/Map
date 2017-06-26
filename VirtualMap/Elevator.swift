import Foundation

class Elevator: SquareCoordinates {
    private(set) var id: String
    private(set) var position: Position
    private(set) var scaleX: Float
    private(set) var scaleY: Float
    private(set) var angle: Int
    
    init(id: String, x1: Int, x2: Int, x3: Int, x4: Int, y1: Int, y2: Int, y3: Int, y4: Int, angle: Int, scaleX: Float, scaleY: Float, position: Position) {
        
        self.id = id
        self.position = position
        self.scaleX = scaleX
        self.scaleY = scaleY
        self.angle = angle
        super.init(x1: x1, x2: x2, x3: x3, x4: x4, y1: y1, y2: y2, y3: y3, y4: y4)
    }

}
