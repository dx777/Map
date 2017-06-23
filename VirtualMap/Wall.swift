import Foundation

class Wall: LineCoordinates {
    private(set) var id: String
    
    init(x1: Int, x2: Int, y1: Int, y2: Int, id: String) {
        self.id = id
        super.init(x1: x1, x2: x2, y1: y1, y2: y2)
    }
}
