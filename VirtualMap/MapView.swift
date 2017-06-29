import UIKit

class MapView: UIView {
    
    private var emptyBeacon = [BeaconRangingPoint]()
    private var floor = Floor(walls: [], doors: [], beacons: [], elevators: [], travolators: [], stairs: [], stacks: [], isneedreview: false)
    private let wallColor = UIColor.black
    private let doorColor = UIColor.red
    private let triangleColor = UIColor.red
    private let perpendicularColor = UIColor.darkGray
    private let elevatorColor = UIColor(red: 0, green: 166.0 / 255.0, blue: 166.0 / 255.0, alpha: 1)
    private let travolatorColor = UIColor(red: 172.0 / 255.0, green: 0, blue: 0, alpha: 1)
    private let stairsColor = UIColor(red: 0, green: 163.0 / 255.0, blue: 19.0 / 255.0, alpha: 1)
    private let stackColor = UIColor(red: 0, green: 30.0 / 255.0, blue: 165.0 / 255.0, alpha: 1)
    private let doorLength = 3.0
    private let elevatorLength = 3.0
    private let travolatorLength = 1
    private let beaconColor = UIColor.green
    private let beaconNoActiveColor = UIColor(red: 20/255.0, green: 154.0/255.0, blue: 53.0/255.0, alpha: 1.0)
    private let beaconFrameColor = UIColor.brown
    private let lineWidthBeaconFrame:CGFloat = 0.25
    private let beaconRadius: CGFloat = 5.0
    private let userColor = UIColor.blue
    private let userFrameColor = UIColor.brown
    private let lineWidthUserFrame:CGFloat = 0.25
    private let userRadius: CGFloat = 5.0
    private let distanceBeaconColor = UIColor.clear
    private let distanceBeaconFrameColor = UIColor.green
    private let lineWidthOfDistanceFrame: CGFloat = 0.5
    private let userRawRadius: CGFloat = 3.0
    private let userRawColor = UIColor.darkGray
    private let userRawFrameColor = UIColor.lightGray
    private let lineWidthOfuserRawFrame: CGFloat = 0.8
    private let line = CAShapeLayer()
    private let doneLine = CAShapeLayer()
    static var pinImage = UIImageView()
    
    
    private var beaconText: NSString = ""
    private let textColor: UIColor = UIColor.red
    private let textFont: UIFont = UIFont(name: "Helvetica Neue", size: 5)!
    
    private var currentUserLocation = CurrentUserLocation()
    private var beaconRangingData: [BeaconRangingPoint] = []
    
    override func draw(_ rect: CGRect) {
        let frameToDraw = CoordinatesConverter(boundsWidth: bounds.width, boundsHeight: bounds.height, paddingX: 5, paddingY: 5)
        let mapWithScaleCoordinaates =  frameToDraw.getSuitableCoordinates(floor: floor, currentUserLocation: currentUserLocation, beaconRangingData: beaconRangingData)
        let lines = mapWithScaleCoordinaates.lines
        let circles = mapWithScaleCoordinaates.circles
        let squares = mapWithScaleCoordinaates.squares
        
        
        drawLines(lines: lines)
        drawCircles(circles: circles)
        drawSquares(squares: squares)
        
        if MapViewController.arrayOfPointsToDraw.isEmpty == false{
            drawRoute()
        } else {
            MapView.pinImage.removeFromSuperview()
        }
        
        
    }
    
    fileprivate func drawLines(lines :[Line]) {
        let wallPath = UIBezierPath()
        let doorPath = UIBezierPath()
        let trianglePath = UIBezierPath()
        let perpendicularPath = UIBezierPath()
        
        for line in lines {
            if line.type == .wall {
                wallPath.move(to: CGPoint(x: line.x1, y: line.y1))
                wallPath.addLine(to: CGPoint(x: line.x2, y: line.y2))
                wallColor.setStroke()
                wallPath.stroke()
            }
            if line.type == .door {
                doorPath.move(to: CGPoint(x: line.x1, y: line.y1))
                doorPath.addLine(to: CGPoint(x: line.x2, y: line.y2))
                doorPath.lineWidth = CGFloat(doorLength)
                doorColor.setStroke()
                doorPath.stroke()
            }
            if line.type == .triangle {
                trianglePath.move(to: CGPoint(x: line.x1, y: line.y1))
                trianglePath.addLine(to: CGPoint(x: line.x2, y: line.y2))
                triangleColor.setStroke()
                trianglePath.stroke()
            }
            if line.type == .perpendicular {
                perpendicularPath.move(to: CGPoint(x: line.x1, y: line.y1))
                perpendicularPath.addLine(to: CGPoint(x: line.x2, y: line.y2))
                perpendicularColor.setStroke()
                perpendicularPath.stroke()
            }
        }
    }
    
    
    fileprivate func drawSquares(squares :[Square]) {
        let elevatorPath = UIBezierPath()
        let elevatorXPath = UIBezierPath()
        let travolatorPath = UIBezierPath()
        let travolatorAdditionalPath = UIBezierPath()
        let stairsPath = UIBezierPath()
        let stairsAdditionalPath = UIBezierPath()
        let stacksPath = UIBezierPath()
        
        for square in squares {
            if square.type == .elevator {
                elevatorPath.move(to: CGPoint(x: square.x1, y: square.y1))
                elevatorPath.addLine(to: CGPoint(x: square.x2, y: square.y2))
                elevatorPath.addLine(to: CGPoint(x: square.x4, y: square.y4))
                elevatorPath.addLine(to: CGPoint(x: square.x3, y: square.y3))
                elevatorPath.lineWidth = CGFloat(elevatorLength)
                elevatorPath.close()
                elevatorColor.setStroke()
                elevatorPath.stroke()
                
                elevatorXPath.move(to: CGPoint(x: square.x1, y: square.y1))
                elevatorXPath.addLine(to: CGPoint(x: square.x4, y: square.y4))
                elevatorXPath.move(to: CGPoint(x: square.x2, y: square.y2))
                elevatorXPath.addLine(to: CGPoint(x: square.x3, y: square.y3))
                elevatorXPath.close()
                elevatorXPath.stroke()
            }
            
            if square.type == .travolator {
                let height: CGFloat = CGFloat(square.y4 - square.y1)
                let width: CGFloat = CGFloat(square.x2 - square.x1)
                travolatorPath.move(to: CGPoint(x: square.x1, y: square.y1))
                travolatorPath.addLine(to: CGPoint(x: square.x2, y: square.y2))
                travolatorPath.addLine(to: CGPoint(x: square.x4, y: (square.y1 + Int(height / 4))))
                travolatorPath.addLine(to: CGPoint(x: square.x3, y: (square.y2 + Int(height / 4))))
                travolatorPath.lineWidth = CGFloat(travolatorLength)
                travolatorPath.close()
                travolatorColor.setStroke()
                travolatorPath.stroke()
                
                travolatorAdditionalPath.move(to: CGPoint(x: square.x1 + Int(width * 0.1), y: square.y1))
                travolatorAdditionalPath.addLine(to: CGPoint(x: square.x1 + Int(width * 0.1), y: square.y4))
                travolatorAdditionalPath.addLine(to: CGPoint(x: square.x1 + Int(width * 0.9), y: square.y1))
                
                let numberOfLines = 17
                let travolatorLeftAdditionalPos = square.x1 + Int(width * 0.1)
                let travolatorRightAdditionalPos = square.x1 + Int(width * 0.9)
                for y in stride(from: numberOfLines, to: 1, by: -1) {
                    let yPos = square.y4 - Int(Float(height) / Float(numberOfLines)) * y
                    // Get right x coordinate using Line equation by points
                    let x = ((yPos - square.y4) * (travolatorRightAdditionalPos - travolatorLeftAdditionalPos) / (square.y1 - square.y4) ) + travolatorLeftAdditionalPos
                    
                    travolatorAdditionalPath.move(to: CGPoint(x: travolatorLeftAdditionalPos, y: yPos))
                    travolatorAdditionalPath.addLine(to: CGPoint(x: x, y: yPos))
                }
                
                travolatorAdditionalPath.lineWidth = CGFloat(travolatorLength)
                travolatorAdditionalPath.stroke()
            }
            
            if square.type == .stairs {
                let height: CGFloat = CGFloat(square.y4 - square.y1)
                let width: CGFloat = CGFloat(square.x2 - square.x1)
                stairsPath.move(to: CGPoint(x: square.x1, y: square.y1))
                stairsPath.addLine(to: CGPoint(x: square.x2, y: square.y2))
                stairsPath.addLine(to: CGPoint(x: square.x4, y: square.y4))
                stairsPath.addLine(to: CGPoint(x: square.x3, y: square.y3))
                stairsPath.close()
                stairsColor.setStroke()
                stairsPath.stroke()
                
                let stairsMiddleTopY = square.y1 + Int(height * 0.42)
                let stairsMiddleBottomY = square.y1 + Int(height * 0.58)
                
                stairsAdditionalPath.move(to: CGPoint(x: square.x1, y: stairsMiddleTopY))
                stairsAdditionalPath.addLine(to: CGPoint(x: square.x2, y: stairsMiddleTopY))
                
                stairsAdditionalPath.move(to: CGPoint(x: square.x1, y: stairsMiddleBottomY))
                stairsAdditionalPath.addLine(to: CGPoint(x: square.x2, y: stairsMiddleBottomY))
                
                let numberOfLines = 7
                let widthPerStair = Float(width) / 7
                for x in 1...numberOfLines {
                    let xPos = Float(square.x1) + widthPerStair * Float(x)
                    stairsAdditionalPath.move(to: CGPoint(x: CGFloat(xPos), y: CGFloat(square.y1)))
                    stairsAdditionalPath.addLine(to: CGPoint(x: CGFloat(xPos), y: CGFloat(stairsMiddleTopY)))
                    
                    
                    stairsAdditionalPath.move(to: CGPoint(x: CGFloat(xPos), y: CGFloat(stairsMiddleBottomY)))
                    stairsAdditionalPath.addLine(to: CGPoint(x: CGFloat(xPos), y: CGFloat(square.y4)))
                }
                
                
                
                stairsAdditionalPath.stroke()
            }
            
            if square.type == .stack {
                stacksPath.move(to: CGPoint(x: square.x1, y: square.y1))
                stacksPath.addLine(to: CGPoint(x: square.x2, y: square.y2))
                stacksPath.addLine(to: CGPoint(x: square.x4, y: square.y4))
                stacksPath.addLine(to: CGPoint(x: square.x3, y: square.y3))
                stacksPath.close()
                stackColor.setFill()
                stacksPath.fill()
            }
        }
    }
    
    fileprivate func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        line.path = linePath.cgPath
        line.strokeColor = UIColor.blue.cgColor
        line.lineWidth = 3
        line.lineJoin = kCALineJoinRound
        self.layer.addSublayer(line)
        
    }
    
    func setFloor (currentFloor: Floor) {
        floor = currentFloor
    }
    
    func setUserPoint(currentUserPoint: CurrentUserLocation, beaconRangingData: [BeaconRangingPoint]) {
        self.currentUserLocation = currentUserPoint
        self.beaconRangingData = beaconRangingData
    }
    
    
    func removeUserPoint(currentUserPoint: CurrentUserLocation, beaconRangingData: [BeaconRangingPoint]) {
        self.currentUserLocation.isLocated = false
        self.beaconRangingData = emptyBeacon
    }
    
    fileprivate func drawRoute() {
        let linePath = UIBezierPath()
        if(currentUserLocation.isOnPath && currentUserLocation.isLocated) {
            var attachedCoordinates : [CGPoint] = []
            // Получаем координаты позиции пользователя на каждую линию маршрута
            for i in 1..<MapViewController.arrayOfPointsToDraw.count {
                let coordinateForAttach = Geometry.getAttachedCoordinates(x: Int((MapViewController.currentUserLoc?.x)!), y: Int((MapViewController.currentUserLoc?.y)!), x1: Int(MapViewController.arrayOfPointsToDraw[i - 1].x), x2: Int(MapViewController.arrayOfPointsToDraw[i].x), y1: Int(MapViewController.arrayOfPointsToDraw[i - 1].y), y2: Int(MapViewController.arrayOfPointsToDraw[i].y))
                attachedCoordinates.append(CGPoint(x: coordinateForAttach[0], y: coordinateForAttach[1]))
            }
            // Получаем найменьшее значение
            var minIndex = 0
            var minDistance = Geometry.distanceBetweenPoints(x1: Double(attachedCoordinates[0].x), y1: Double(attachedCoordinates[0].x), x2: Double((MapViewController.currentUserLoc?.x)!), y2: Double((MapViewController.currentUserLoc?.y)!))
            var distance = 0.0
            for i in 1..<attachedCoordinates.count {
                distance = Geometry.distanceBetweenPoints(x1: Double(attachedCoordinates[i].x), y1: Double(attachedCoordinates[i].y), x2: Double((MapViewController.currentUserLoc?.x)!), y2: Double((MapViewController.currentUserLoc?.y)!))
                if(minDistance > distance) {
                    minDistance = distance
                    minIndex = i
                }
            }
            
            minIndex = minIndex + 1
            
            let doneLinePath = UIBezierPath()
            
            doneLinePath.move(to: MapViewController.arrayOfPointsToDraw[0])
            
            for i in 0..<minIndex {
                doneLinePath.addLine(to: MapViewController.arrayOfPointsToDraw[i])
            }
            doneLinePath.addLine(to: CGPoint(x: (MapViewController.currentUserLoc?.x)!, y: (MapViewController.currentUserLoc?.y)!))
            
            linePath.move(to: CGPoint(x: (MapViewController.currentUserLoc?.x)!, y: (MapViewController.currentUserLoc?.y)!))
    
            for i in minIndex..<MapViewController.arrayOfPointsToDraw.count {
                linePath.addLine(to: MapViewController.arrayOfPointsToDraw[i])
            }
            
            doneLine.path = doneLinePath.cgPath
            doneLine.strokeColor = UIColor(red: 90.0 / 255.0, green: 169.0 / 255.0, blue: 221.0 / 255.0, alpha: 0.5).cgColor
            doneLine.lineWidth = 3
            doneLine.lineJoin = kCALineJoinRound
            doneLine.fillColor = UIColor.clear.cgColor
            self.layer.insertSublayer(doneLine, at: 0)
        } else {
            linePath.move(to: MapViewController.arrayOfPointsToDraw[0])
            for point in MapViewController.arrayOfPointsToDraw {
                linePath.addLine(to: point)
            }
        }
        
        line.path = linePath.cgPath
        line.strokeColor = UIColor(red: 90.0 / 255.0, green: 169.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).cgColor
        line.lineWidth = 3
        line.lineJoin = kCALineJoinRound
        line.fillColor = UIColor.clear.cgColor
        self.layer.insertSublayer(line, at: 0)
        
        let lastpoint = MapViewController.arrayOfPointsToDraw.last
        
        MapView.pinImage.removeFromSuperview()
        let pin = UIImage(named: "pin")
        MapView.pinImage.removeFromSuperview()
        MapView.pinImage.image = pin
        MapView.pinImage.frame = CGRectMake((lastpoint?.x)!, (lastpoint?.y)!, 40, 40)
        MapView.pinImage.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(MapView.pinImage)
        MapView.pinImage.center = (lastpoint)!
        
    }
    
    fileprivate func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    
    fileprivate func drawCircles(circles: [Circle]) {
        let layerViews = layer.sublayers
        if layerViews != nil {
            for view in layerViews! {
                if type(of: view) === CAShapeLayer.self {
                    view.removeFromSuperlayer()
                    
                }
            }
        }
        
        for circle in circles {
            
            if type(of: circle) === BeaconCircle.self  {
                if (circle as! BeaconCircle).correctedDistance  == 0 {
                    infoToDrawCircle(circle: circle, radius: beaconRadius, color: beaconNoActiveColor.cgColor, frameColor: beaconFrameColor.cgColor, frameWidth: lineWidthBeaconFrame)
                    drawBeaconText(circle: circle as! BeaconCircle)
                } else {
                    infoToDrawCircle(circle: circle, radius: beaconRadius, color: beaconColor.cgColor, frameColor: beaconFrameColor.cgColor, frameWidth: lineWidthBeaconFrame)
                    drawBeaconText(circle: circle as! BeaconCircle)
                }
                
                if type(of: circle) === BeaconCircle.self && (circle as! BeaconCircle).correctedDistance != 0 {
                    infoToDrawCircle(circle: circle, radius: CGFloat((circle as! BeaconCircle).correctedDistance), color: distanceBeaconColor.cgColor, frameColor: distanceBeaconFrameColor.cgColor, frameWidth: lineWidthOfDistanceFrame)
                    //   infoToDrawCircle(circle: circle, radius: CGFloat((circle as! BeaconCircle).notCorrectedDistance), color: UIColor.gray.cgColor, frameColor: distanceBeaconFrameColor.cgColor, frameWidth: lineWidthOfDistanceFrame)
                }
                
            } else if type(of: circle) === UserCircle.self {
                infoToDrawCircle(circle: circle, radius: userRadius, color: userColor.cgColor, frameColor: userFrameColor.cgColor, frameWidth: lineWidthUserFrame)
            } else if type (of: circle) === UserRawCircle.self {
                infoToDrawCircle(circle: circle, radius: userRawRadius, color: userRawColor.cgColor, frameColor: userRawFrameColor.cgColor, frameWidth: lineWidthOfuserRawFrame)
            } else {
                Logger.logMessage(message: "incorrect circle type", level: .error)
                break
            }
        }
    }
    
    fileprivate func drawBeaconText (circle: BeaconCircle) {
        let attributes: NSDictionary = [
            NSForegroundColorAttributeName: textColor,
            NSFontAttributeName: textFont
        ]
        let minor = circle.minor
        let correctDistance = Int(round(100 * circle.correctDistanceForText) / 100)
        let notCorrectDistance = Int(round(100 * circle.notCorrectDistanceForText) / 100)
        beaconText = "m: \(minor), cd: \(correctDistance), nd: \(notCorrectDistance)" as NSString
        if circle.x > Int((bounds.width - 50)) {
            beaconText.draw(at: CGPoint(x: circle.x - 70, y: circle.y + 5), withAttributes: attributes as? [String : Any])
        } else if circle.x < 20 {
            beaconText.draw(at: CGPoint(x: circle.x + 5, y: circle.y + 5), withAttributes: attributes as? [String : Any])
        } else {
            beaconText.draw(at: CGPoint(x: circle.x + 6, y: circle.y + 5), withAttributes: attributes as? [String : Any])
        }
    }
    
    fileprivate func infoToDrawCircle (circle: Circle, radius: CGFloat, color: CGColor, frameColor: CGColor, frameWidth: CGFloat) {
        let center = CGPoint(x: circle.x, y: circle.y)
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = color
        shapeLayer.lineWidth = frameWidth
        shapeLayer.strokeColor = frameColor
        layer.addSublayer(shapeLayer)
    }
    
    
    private func unscaleTappedPoint (tappedPoint: CGPoint, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        return CGPoint(x: Int(CGFloat(tappedPoint.x - offsetX) / scale) , y: Int(CGFloat(tappedPoint.y - offsetY) / scale))
        
    }
}

