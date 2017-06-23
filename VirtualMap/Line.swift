import Foundation
enum TypeOfLine {
    case wall
    case door
    case triangle
    case perpendicular
    
    init() {
        self = .wall
    }
}

class Line: LineCoordinates {
    private(set) var type: TypeOfLine
    
    init(x1: Int, x2: Int, y1: Int, y2: Int, type: TypeOfLine) {
        self.type = type
        super.init(x1: x1, x2: x2, y1: y1, y2: y2)
    }
}
