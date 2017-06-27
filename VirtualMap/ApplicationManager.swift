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
        
        let mapId = 1
        let floorId = 1
        if(position.isLocated) {
            let xPos = Int((position.point?.x)!)
            let yPos = Int((position.point?.y)!)
            let url = "https://teleroamer.com/api/v1/position/correct?x=\(xPos)&y=\(yPos)&map=\(mapId)&floor=\(floorId)"
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                
                let result = response.result
                
                if let dict = result.value as? Dictionary<String, Any>{
                    position.point = CGPoint(x: Int(dict["x"] as! String)!, y: Int(dict["y"] as! String)!)
                    self.currentUserPoint(position, beacon)
                }
            }
        }
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
