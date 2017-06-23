import Foundation

class MapBounds {
    private(set) var minX: Int
    private(set) var maxX: Int
    private(set) var minY: Int
    private(set) var maxY: Int
    
    init(minX: Int, maxX: Int, minY: Int, maxY: Int) {
        self.minX = minX
        self.maxX = maxX
        self.minY = minY
        self.maxY = maxY
    }
}
