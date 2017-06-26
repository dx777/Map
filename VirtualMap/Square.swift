import Foundation
enum TypeOfSquare {
    case elevator
    
    init() {
        self = .elevator
    }
}

class Square: SquareCoordinates {
    private(set) var type: TypeOfSquare
    
    init(x1: Int, x2: Int, x3: Int, x4: Int, y1: Int, y2: Int, y3: Int, y4: Int, type: TypeOfSquare) {
        self.type = type
        super.init(x1: x1, x2: x2, x3: x3, x4: x4, y1: y1, y2: y2, y3: y3, y4: y4)
    }
}
