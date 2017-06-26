import Foundation
import UIKit

var locX:Int?
var locY: Int?
var userPoint: CGPoint?

var pointsDict = [String:[Dictionary <String, Any>]]()


class CoordinatesConverter {
    private(set) var boundsWidth: CGFloat
    private(set) var boundsHeight: CGFloat
    private(set) var paddingX: Int
    private(set) var paddingY: Int
    static var unScaledUserPoint: CGPoint?
    static var scale: CGFloat!
    static var offsets: MapOffset!
    
    
    
    
    
    init(boundsWidth: CGFloat, boundsHeight: CGFloat, paddingX:Int, paddingY: Int) {
        self.boundsWidth = boundsWidth
        self.boundsHeight = boundsHeight
        self.paddingX = paddingX
        self.paddingY = paddingY
    }
    
    func getSuitableCoordinates (floor: Floor, currentUserLocation: CurrentUserLocation, beaconRangingData: [BeaconRangingPoint]) -> DrawObject {
        
        let walls = floor.walls
        let doors = floor.doors
        let beacons = floor.beacons
        let elevators = floor.elevators
        let closestBeacons = beaconRangingData.filter {$0.isClosest == true}
        var linesOfClosetBeacons: [Line] = []
        if !closestBeacons.isEmpty {
            linesOfClosetBeacons = [Line(x1: closestBeacons[0].x, x2: closestBeacons[1].x, y1: closestBeacons[0].y, y2: closestBeacons[1].y, type: .triangle),
                                    Line(x1: closestBeacons[1].x, x2: closestBeacons[2].x, y1: closestBeacons[1].y, y2: closestBeacons[2].y, type: .triangle),
                                    Line(x1: closestBeacons[0].x, x2: closestBeacons[2].x, y1: closestBeacons[0].y, y2: closestBeacons[2].y, type: .triangle)]
        }
        var perpendiculars: [Line] = []
        
        if walls.isEmpty {
            return DrawObject(lines: [], circles: [], squares: [])
        }
        
        let minAndMaxCoordinates = getMinAndMaxCoordinates(array: walls)
        let scale = getScale(mapBounds: minAndMaxCoordinates,
                             boundsWidth: self.boundsWidth,
                             boundsHeight: self.boundsHeight,
                             paddingX: self.paddingX,
                             paddingY: self.paddingY)
        CoordinatesConverter.scale = scale
        let offsets = getOffset(mapBounds: minAndMaxCoordinates, boundsWidth: boundsWidth, boundsHeight: boundsHeight, scale: scale)
        CoordinatesConverter.offsets = offsets
        let linesOfWalls: [Line] = getLines(array: walls, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY, type: .wall)
        let doorsCoordinates = doorCoordinates(doors: doors, walls: walls)
        let linesForDoors: [Line] = getLines(array: doorsCoordinates, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY, type: .door)
        let linesForTriangle: [Line] = getLines(array: linesOfClosetBeacons, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY, type: .triangle)
        var allCirclesInMap: [Circle] = getCircles(array: beacons, beaconRangingData: beaconRangingData, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY)
        let squaresOfElevators: [Square] = getSquares(array: elevators, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY, type: .elevator)
        
        // Make here squares operations

        
        if currentUserLocation.isLocated {
            let circleForUser: Circle = getUserCircle(currentUserLocation: currentUserLocation, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY)
            locX = circleForUser.x
            locY = circleForUser.y
            userPoint = CGPoint(x: locX!, y: locY!)
            
            let unscalepoint = unscaledUserPoint(userPoint: userPoint!, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY)
            CoordinatesConverter.unScaledUserPoint = unscalepoint
            print("UNSCALED USER POINT \(unscalepoint)")
            
            
            let circleForRawUser = getRawUserCircle(currentUserLocation: currentUserLocation, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY)
            allCirclesInMap.append(circleForUser)
            allCirclesInMap.append(circleForRawUser)
            perpendiculars.append(Line(x1: Int((currentUserLocation.abp?.x)!), x2: Int((currentUserLocation.pointForDrawPerpendiculars?.x)!), y1: Int((currentUserLocation.abp?.y)!), y2: Int((currentUserLocation.pointForDrawPerpendiculars?.y)!), type: .perpendicular))
            perpendiculars.append(Line(x1: Int((currentUserLocation.acp?.x)!), x2: Int((currentUserLocation.pointForDrawPerpendiculars?.x)!), y1: Int((currentUserLocation.acp?.y)!), y2: Int((currentUserLocation.pointForDrawPerpendiculars?.y)!), type: .perpendicular))
        }
        let linesForPerpendicular: [Line] = getLines(array: perpendiculars, scale: scale, offsetX: offsets.offsetX, offsetY: offsets.offsetY, type: .perpendicular)
        let allLinesInMap = linesOfWalls + linesForDoors + linesForTriangle + linesForPerpendicular
        let allSquaresInMap = squaresOfElevators;
        return DrawObject(lines: allLinesInMap, circles: allCirclesInMap, squares: allSquaresInMap)
    }
    
    private func getMinAndMaxCoordinates(array: [Wall]) -> MapBounds {
        let arrayXCoordinates = array.map{$0.x1} + array.map{$0.x2}
        let arrayYCoordinates = array.map{$0.y1} + array.map{$0.y2}
        return MapBounds(minX: arrayXCoordinates.min()!,
                         maxX: arrayXCoordinates.max()!,
                         minY: arrayYCoordinates.min()!,
                         maxY: arrayYCoordinates.max()!)
    }
    
    private func getScale(mapBounds: MapBounds, boundsWidth: CGFloat, boundsHeight: CGFloat, paddingX: Int, paddingY: Int) -> CGFloat {
        let width = (boundsWidth - CGFloat(2 * paddingX)) / CGFloat(mapBounds.maxX - mapBounds.minX)
        let height = (boundsHeight - CGFloat(2 * paddingY)) / CGFloat(mapBounds.maxY - mapBounds.minY)
        
        if width < height {
            return width
        } else {
            return height
        }
    }
    
    private func getOffset(mapBounds: MapBounds, boundsWidth: CGFloat, boundsHeight: CGFloat, scale: CGFloat) -> MapOffset {
        let xLength = mapBounds.maxX - mapBounds.minX
        let yLength = mapBounds.maxY - mapBounds.minY
        let centerXOfMap = CGFloat(mapBounds.minX) + CGFloat(xLength / 2)
        let centerYOfMap = CGFloat(mapBounds.minY) + CGFloat(yLength / 2)
        let offsetX = boundsWidth / 2 - centerXOfMap * scale
        let offsetY = boundsHeight / 2 - centerYOfMap * scale
        return MapOffset(offsetX: offsetX, offsetY: offsetY)
    }
    
    private func getLines(array: [LineCoordinates], scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat, type: TypeOfLine) -> [Line] {
        var result: [Line] = []
        //var type: TypeOfLine = .wall
        
        for line in array {
            //            if type(of: line) === Wall.self {
            //                type = .wall
            //            } else if type(of: line) === DoorWithCoordinates.self {
            //                type = .door
            //            } else if line type(of: line) === .perpendicular {
            //                type = .triangle
            //            }
            result.append(Line(x1: Int(CGFloat(line.x1) * scale + offsetX),
                               x2: Int(CGFloat(line.x2) * scale + offsetX),
                               y1: Int(CGFloat(line.y1) * scale + offsetY),
                               y2: Int(CGFloat(line.y2) * scale + offsetY),
                               type: type))
        }
        return result
    }
    
    private func doorCoordinates(doors: [Door], walls: [Wall]) -> [DoorWithCoordinates] {
        var result: [DoorWithCoordinates] = []
        
        for door in doors {
            for wall in walls {
                if door.owner == wall.id {
                    result.append(getXYCoordinates(start: door.distanceStart, end: door.distanceEnd, wall: wall))
                } else {
                    continue
                }
            }
        }
        return result
    }
    
    private func getXYCoordinates(start: Int, end: Int, wall: Wall) -> DoorWithCoordinates {
        let length = Int(sqrt(Double(pow((Double(wall.x2 - wall.x1)), 2) + pow((Double(wall.y2 - wall.y1)), 2))))
        let x1door = wall.x1 + Int(Double(start) / Double(length) * Double((wall.x2 - wall.x1)))
        let x2door = wall.x1 + Int(Double(end) / Double(length) * Double((wall.x2 - wall.x1)))
        let y1door = wall.y1 + Int(Double(start) / Double(length) * Double((wall.y2 - wall.y1)))
        let y2door = wall.y1 + Int(Double(end) / Double(length) * Double((wall.y2 - wall.y1)))
        return DoorWithCoordinates(x1: x1door, x2: x2door, y1: y1door, y2: y2door)
    }
    
    private func getSquares( array: [SquareCoordinates], scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat, type: TypeOfSquare) -> [Square] {
        var result: [Square] = []
        
        for square in array {
            result.append(Square(x1: Int(CGFloat(square.x1) * scale + offsetX),
                                 x2: Int(CGFloat(square.x2) * scale + offsetX),
                                 x3: Int(CGFloat(square.x3) * scale + offsetX),
                                 x4: Int(CGFloat(square.x4) * scale + offsetX),
                                 y1: Int(CGFloat(square.y1) * scale + offsetY),
                                 y2: Int(CGFloat(square.y2) * scale + offsetY),
                                 y3: Int(CGFloat(square.y3) * scale + offsetY),
                                 y4: Int(CGFloat(square.y4) * scale + offsetY),
                                 type: type))
        }
        return result
    }
    
    private func getCircles( array: [Beacon], beaconRangingData: [BeaconRangingPoint], scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> [BeaconCircle] {
        return (array.filter {
            beacon in
            let containedBeacons = beaconRangingData.filter {
                beaconRD in
                return beaconRD.uuid == beacon.uuid && beaconRD.major == beacon.major && beaconRD.minor == beacon.minor
            }
            let doesHaveSameBeacons = containedBeacons.count == 0
            return doesHaveSameBeacons
        }).map {
            BeaconCircle(correctedDistance: 0,
                         minor: $0.minor,
                         notCorrectedDistance: 0,
                         correctDistanceForText: 0,
                         notCorrectDistanceForText: 0,
                         x: Int(CGFloat($0.x) * scale + offsetX),
                         y: Int(CGFloat($0.y) * scale + offsetY))} + beaconRangingData.map {
                            BeaconCircle(
                                correctedDistance: $0.isActive ? $0.previousDistanceCorrectedByKalman * Double(scale) : 0,
                                minor: $0.minor,
                                notCorrectedDistance:  $0.isActive ? $0.currentRangingDistance * Double(scale) : 0,
                                correctDistanceForText: $0.isActive ? $0.previousDistanceCorrectedByKalman : 0,
                                notCorrectDistanceForText: $0.currentRangingDistance,
                                x: Int(CGFloat($0.x) * scale + offsetX),
                                y: Int(CGFloat($0.y) * scale + offsetY))}
    }
    
    private func getUserCircle (currentUserLocation: CurrentUserLocation, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> UserCircle {
        return UserCircle(x: Int(CGFloat(currentUserLocation.point!.x) * scale + offsetX) , y: Int(CGFloat(currentUserLocation.point!.y) * scale + offsetY))
    }
    private func getRawUserCircle (currentUserLocation: CurrentUserLocation, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> UserRawCircle {
        return UserRawCircle(x: Int(CGFloat(currentUserLocation.listPoints.last!.x) * scale + offsetX) , y: Int(CGFloat(currentUserLocation.listPoints.last!.y) * scale + offsetY))
        
    }
    
    private func unscaleTappedPoint (tappedPoint: CGPoint, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        //        return CGPoint(x: Int(CGFloat(tappedPoint.x) * scale + offsetX) , y: Int(CGFloat(tappedPoint.y) * scale + offsetY))
        return CGPoint(x: Int(CGFloat(tappedPoint.x) / scale - offsetX) , y: Int(CGFloat(tappedPoint.y) / scale - offsetY))
        
    }
    
    private func unscaledUserPoint (userPoint: CGPoint, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        //        return CGPoint(x: Int(CGFloat(tappedPoint.x) * scale + offsetX) , y: Int(CGFloat(tappedPoint.y) * scale + offsetY))
        return CGPoint(x: Int(CGFloat(userPoint.x) / scale - offsetX) , y: Int(CGFloat(userPoint.y) / scale - offsetY))
        
    }
    

    

    
    
}








