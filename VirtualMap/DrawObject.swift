import Foundation

class DrawObject {
    private(set) var lines: [Line]
    private(set) var circles: [Circle]
    private(set) var squares: [Square]
   
    init(lines: [Line], circles: [Circle], squares: [Square]) {
        self.lines = lines
        self.circles = circles
        self.squares = squares
    }
}
