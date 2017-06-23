import Foundation

class DrawObject {
    private(set) var lines: [Line]
    private(set) var circles: [Circle]
   
    init(lines: [Line], circles: [Circle]) {
        self.lines = lines
        self.circles = circles
    }
}
