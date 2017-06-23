import Foundation

class LineCoordinates {
    private(set) var x1: Int
    private(set) var x2: Int
    private(set) var y1: Int
    private(set) var y2: Int
    
    init(x1: Int, x2: Int, y1: Int, y2: Int) {
        self.x1 = x1
        self.x2 = x2
        self.y1 = y1
        self.y2 = y2
    }
}
