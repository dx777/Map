import Foundation
import UIKit
import Alamofire

var gotFloor: Floor?
class ApplicationManager {
    static let sharedInstance = ApplicationManager()
    private let beaconManager: BeaconManagerProtocol = TestBeaconManager()
    private var allBeaconsFromAPI: [Beacon] = []
    private let geoLocation = GeoLocation()
    var currentUserPoint: (CurrentUserLocation, [BeaconRangingPoint]) -> () = {currentUserPoint, beaconRangingData in return}
    var gotFloorData: (Floor) -> () = {floor in return}
    
    func onApplicationStart () {
        Logger.logMessage(message: "onApplicationStart start", level: .info)
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
             Logger.logMessage(message: "version = \(version)", level: .info)        }
        beaconManager.setGotMaxBeaconInfoFunc(gotMaxBeaconInfo: gotMaxBeaconInfo)
        beaconManager.setGotRangedBeaconsFunc(gotRangedBeaconsInfo: gotRangedBeaconsInfo)
        beaconManager.startGettingAllBeacons()
        MapViewController.onApplicationStarted = true
    }
    
    func gotMaxBeaconInfo(_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> () {
        let path = "{\"beacons\":[{\"minor\":\"\(minor)\",\"major\":\"\(major)\",\"uuid\":\"\(uuid)\"}]}"
        Logger.logMessage(message: "path is \(path)", level: .info)
        getMap(path: path)
    }
    
   
    func gotRangedBeaconsInfo(_ rangingBeacons: [BeaconRangingData]) -> () {
        Logger.logMessage(message: "all ranged beacons: \(rangingBeacons)", level: .info)
        let currentUserLocation = geoLocation.getBeaconPoint(beaconRangingData: rangingBeacons, beaconsFromAPI: allBeaconsFromAPI)
        getCorrectedPosition(position: currentUserLocation.0, beacon: currentUserLocation.1)
        for beacon in rangingBeacons {
            Logger.logMessage(message: "Distance is : \(beacon.distance)", level: .info)
        }
    }
    
    private func getCorrectedPosition(position: CurrentUserLocation, beacon:[BeaconRangingPoint]) {
        
        var mapId = 1
        var floorId = 1
        if(position.isLocated) {
            let xPos = Int((position.point?.x)!)
            let yPos = Int((position.point?.y)!)
            mapId = autoShopId
            floorId = autofloor
            let url = "https://teleroamer.com/api/v1/position/correct?x=\(xPos)&y=\(yPos)&map=\(mapId)&floor=\(floorId)"
            Logger.logMessage(message: url, level: .info)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, Any>{
                    position.point = CGPoint(x: Int(dict["x"] as! String)!, y: Int(dict["y"] as! String)!)
                    self.currentUserPoint(position, beacon)
                    self.getTotalDistance(position: position)
                }
            }
        } else {
            self.currentUserPoint(position, beacon)
            getTotalDistance(position: position)
        }
    }
    
    //Считаем общую дистанцию
    private func getTotalDistance(position: CurrentUserLocation) {
        var totalLength : Double = 0
        var prevPoint: CGPoint = CGPoint(x: 0, y: 0)
        var skip: Bool = false
        for floorKey in pointsDict.keys {
            if(Int(floorKey) == autofloor) {
                if(pointsDict["\(floorKey)"]!.count == 0 || (MapViewController.currentUserLoc == nil)) {
                    continue
                }
                Logger.logMessage(message: NSStringFromCGPoint(MapViewController.currentUserLoc!), level: .info)
                var attachedCoordinates : [CGPoint] = []
                // Получаем координаты позиции пользователя на каждую линию маршрута
                for i in 1..<pointsDict["\(floorKey)"]!.count {
                    let coordinate = CGPoint(x: (pointsDict["\(floorKey)"]![i]["x"] as? Int)!, y: (pointsDict["\(floorKey)"]![i]["y"] as? Int)!)
                    let prevCoordinate = CGPoint(x: (pointsDict["\(floorKey)"]![i-1]["x"] as? Int)!, y: (pointsDict["\(floorKey)"]![i-1]["y"] as? Int)!)
                    let coordinateForAttach = Geometry.getAttachedCoordinates(x: Int((MapViewController.currentUserLoc?.x)!), y: Int((MapViewController.currentUserLoc?.y)!), x1: Int(prevCoordinate.x), x2: Int(coordinate.x), y1: Int(prevCoordinate.y), y2: Int(coordinate.y))
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
                var prevPoint : CGPoint = CGPoint(x: (MapViewController.currentUserLoc?.x)!, y: (MapViewController.currentUserLoc?.y)!)
                prevPoint = CoordinatesConverter.unscaleTappedPoint(tappedPoint: prevPoint, scale: CoordinatesConverter.scale, offsetX: CoordinatesConverter.offsets.offsetX, offsetY: CoordinatesConverter.offsets.offsetY)
                for i in minIndex..<pointsDict["\(floorKey)"]!.count {
                    let point = CGPoint(x: (pointsDict["\(floorKey)"]![i]["x"] as? Int)!, y: (pointsDict["\(floorKey)"]![i]["y"] as? Int)!)
                    totalLength += Geometry.distanceBetweenPoints(x1: Double(prevPoint.x), y1: Double(prevPoint.y), x2: Double(point.x), y2: Double(point.y))
                    prevPoint = point
                }
            } else {
                for point in pointsDict["\(floorKey)"]! {
                        let x = point["x"] as? Int
                        let y = point["y"] as? Int
                        let coordinate = CGPoint(x: x!, y: y!)
                        
                        if(skip) {
                            totalLength += Geometry.distanceBetweenPoints(x1: Double(prevPoint.x), y1: Double(prevPoint.y), x2: Double(coordinate.x), y2: Double(coordinate.y))
                        }
                        prevPoint = CGPoint(x: Double(coordinate.x), y: Double(coordinate.y))
                        skip = true
                }
            }
            skip = false
        }
        
        totalLength /= DISTANCE_MULTIPLIER
        
        Logger.logMessage(message: "Total length: \(totalLength)", level: .info)
        
        let dataDict:[String: Double] = ["distance": totalLength]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ChangeDistance"), object: nil, userInfo: dataDict)
    }
    
    private func getMap(path: String) {
        Logger.logMessage(message: "START get map and path : \(path)", level: .info)
        
        CurrentAPIClient(request: Request.getPathForRequest(path: path)).fetchCurrentFloor {
            result in
            switch result {
            case .Success(let currentFloor):
                if currentFloor == nil {
                    Logger.logMessage(message: "no floor class from API", level: .warn)
                    return
                }
                self.gotFloorData(currentFloor!)
                gotFloor = currentFloor
                let beaconsFromAPI = currentFloor!.beacons

                
                if beaconsFromAPI.count == 0 {
                    Logger.logMessage(message: "no beacons from API", level: .warn)
                    return
                }
                self.allBeaconsFromAPI = beaconsFromAPI
                let UUIDs = beaconsFromAPI.map{$0.uuid}
                self.beaconManager.startRangeBeacons(UUIDs: UUIDs )
                
            case .Failure(let error):
                Logger.logMessage(message: "error is: \(error)", level: .error)
            case .NOInternetConnection:
                 Logger.logMessage(message: "No internet connection", level: .error)
            // default: break
            }
        }
    }
}
