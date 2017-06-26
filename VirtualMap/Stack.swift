import Foundation

class Stack: SquareCoordinates {
    
    private(set) var id: String
    
    init(id: String, x1: Int, x2: Int, x3: Int, x4: Int, y1: Int, y2: Int, y3: Int, y4: Int) {
        
        self.id = id
        super.init(x1: x1, x2: x2, x3: x3, x4: x4, y1: y1, y2: y2, y3: y3, y4: y4)
    }
    
}
