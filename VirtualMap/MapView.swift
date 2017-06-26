import UIKit

class MapView: UIView {
    
    private var emptyBeacon = [BeaconRangingPoint]()
    private var floor = Floor(walls: [], doors: [], beacons: [], elevators: [], travolators: [], isneedreview: false)
    private let wallColor = UIColor.black
    private let doorColor = UIColor.red
    private let triangleColor = UIColor.red
    private let perpendicularColor = UIColor.darkGray
    private let elevatorColor = UIColor(red: 0, green: 166.0 / 255.0, blue: 166.0 / 255.0, alpha: 1)
    private let doorLength = 3.0
    private let elevatorLength = 3.0
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
        linePath.move(to: MapViewController.arrayOfPointsToDraw[0])
        for point in MapViewController.arrayOfPointsToDraw {
            linePath.addLine(to: point)
            
        }
        line.path = linePath.cgPath
        line.strokeColor = UIColor.blue.cgColor
        line.lineWidth = 3
        line.lineJoin = kCALineJoinRound
        line.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(line)
        
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
}

