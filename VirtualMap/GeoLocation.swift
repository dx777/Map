import Foundation

class GeoLocation {
    private var allBeaconsRangingPoint: [BeaconRangingPoint] = []
    private let userHeight: Double = 140
    private let kalmanSize = 10
    private let scale: Double = 100
    private var isStart: Bool = false
    private var currentUserLocation = CurrentUserLocation()
    static  var userLocated = false
    
    
    func getBeaconPoint(beaconRangingData: [BeaconRangingData], beaconsFromAPI: [Beacon]) -> (CurrentUserLocation, [BeaconRangingPoint]) {
        
        let beacons = isBeaconRangingInAPI(beaconRangingData: beaconRangingData, beaconsFromAPI: beaconsFromAPI)
        getAllBeaconRangingPoint(beaconsRangingPoint : beacons)
        let activeBeacons = allBeaconsRangingPoint.filter {$0.isActive}
        let closestBeacons = getClosestBeacons()
        correctByTriangle(closestBeacons: closestBeacons)
        correctByHeight(beacons: activeBeacons)
        saveToAllDistances(beacons: activeBeacons)
        correctByKalman(beaconsRangingPoint: activeBeacons)
        
        if closestBeacons.count != 3 {
            currentUserLocation.isLocated = false
            
        } else {
            getUserPoint(beacons: closestBeacons)
        }
        return (currentUserLocation, allBeaconsRangingPoint)
    }
    
    private func isBeaconRangingInAPI (beaconRangingData: [BeaconRangingData], beaconsFromAPI: [Beacon]) -> [BeaconRangingPoint] {
        Logger.logMessage(message: "start to check ranged beacons with beacons from API", level: .info)
        
        return ((beaconRangingData.map {
            beaconRD  -> BeaconRangingPoint? in
            let theSameAPIBeacon = (beaconsFromAPI.filter {$0.uuid == beaconRD.uuid && $0.major == Int(beaconRD.major) && $0.minor == Int(beaconRD.minor)}).first
            if theSameAPIBeacon != nil {
                return BeaconRangingPoint(x: theSameAPIBeacon!.x,
                                          y: theSameAPIBeacon!.y,
                                          height: theSameAPIBeacon!.heightAboveTheFloor,
                                          uuid: theSameAPIBeacon!.uuid,
                                          major: theSameAPIBeacon!.major,
                                          minor: theSameAPIBeacon!.minor,
                                          distance: beaconRD.distance * scale)
            } else {
                return nil
            }
        }).filter {$0 != nil}.map {$0!}).sorted{$0.distance < $1.distance}
    }
    
    private func getAllBeaconRangingPoint(beaconsRangingPoint : [BeaconRangingPoint]) {
        Logger.logMessage(message: "allBeaconRangingPoint:  \(beaconsRangingPoint)", level: .info)
    
        for beacon in allBeaconsRangingPoint {
            beacon.isActive = false
            beacon.currentRangingDistance = 0
        }
        
        
        for beaconRangingPoint in beaconsRangingPoint {
            var exist = false
            for oneBeaconRangingPoint in allBeaconsRangingPoint {
                if beaconRangingPoint.uuid == oneBeaconRangingPoint.uuid && beaconRangingPoint.major == oneBeaconRangingPoint.major && beaconRangingPoint.minor == oneBeaconRangingPoint.minor {
                    oneBeaconRangingPoint.currentRangingDistance = beaconRangingPoint.distance
                    oneBeaconRangingPoint.distance = beaconRangingPoint.distance
                    oneBeaconRangingPoint.isActive = beaconRangingPoint.distance <= 0 ? false : true
                    exist = true
                    
                }
            }
            if exist == false {
                beaconRangingPoint.isActive = beaconRangingPoint.distance <= 0 ? false : true
                beaconRangingPoint.currentRangingDistance = beaconRangingPoint.distance
                allBeaconsRangingPoint.append(beaconRangingPoint)
            }
        }
        
        for u in allBeaconsRangingPoint {
            Logger.logMessage(message: "\(u.currentRangingDistance), \(u.previousDistanceCorrectedByKalman)", level: .info)
        }
    }
    
    private func getClosestBeacons() -> [BeaconRangingPoint] {
        Logger.logMessage(message: "start to get closest beacons", level: .info)
        var threeClosestBeacons:[BeaconRangingPoint] = []
        if allBeaconsRangingPoint.count < 3 {
            threeClosestBeacons = []
            return threeClosestBeacons
        }
        for beacon in allBeaconsRangingPoint {
            beacon.isClosest = false
        }
        let sortedAllBeaconRangingPoint = (allBeaconsRangingPoint.filter {$0.isActive}).sorted{$0.currentRangingDistance < $1.currentRangingDistance}
        
        
        
        for beacon in 0...2 {
            sortedAllBeaconRangingPoint[beacon].isClosest = true
            threeClosestBeacons.append(sortedAllBeaconRangingPoint[beacon])
        }
        Logger.logMessage(message: "closest beacons: 1: \(threeClosestBeacons[0].minor), \(threeClosestBeacons[0].currentRangingDistance), 2: \(threeClosestBeacons[1].minor), \(threeClosestBeacons[1].currentRangingDistance), 3: \(threeClosestBeacons[2].minor), \(threeClosestBeacons[2].currentRangingDistance)", level: .info)
       
        return threeClosestBeacons
    }
    
    private func correctByTriangle(closestBeacons: [BeaconRangingPoint]) {
         Logger.logMessage(message: "correctByTriangle using closest beacons", level: .info)
        
        if closestBeacons.isEmpty {
            return
        }
        
        let aBeaconRangingPoint = closestBeacons[0]
        let bBeaconRangingPoint = closestBeacons[1]
        let cBeaconRangingPoint = closestBeacons[2]
        
        let ab = sideLength(x1: aBeaconRangingPoint.x, y1: aBeaconRangingPoint.y, x2:bBeaconRangingPoint.x, y2: bBeaconRangingPoint.y)
        let ac = sideLength(x1: aBeaconRangingPoint.x, y1: aBeaconRangingPoint.y, x2: cBeaconRangingPoint.x, y2: cBeaconRangingPoint.y)
        let bc = sideLength(x1: bBeaconRangingPoint.x, y1: bBeaconRangingPoint.y, x2: cBeaconRangingPoint.x, y2: cBeaconRangingPoint.y)
        let al = (ab - ac) > 0 ? ab : ac
        let bl = (ab - bc) > 0 ? ab : bc
        let cl = (bc - ac) > 0 ? bc : ac
        
        if aBeaconRangingPoint.distance > al {
            aBeaconRangingPoint.distance = al
        }
        
        
        if bBeaconRangingPoint.distance > bl {
            bBeaconRangingPoint.distance = bl
        }
        
        if cBeaconRangingPoint.distance > cl {
            cBeaconRangingPoint.distance = cl
        }
        Logger.logMessage(message: "abeaconDistance = \(aBeaconRangingPoint.distance), bbeaconDistance = \(bBeaconRangingPoint.distance), cbeaconDistance = \(cBeaconRangingPoint.distance)", level: .info)
    }
    
    private func sideLength(x1: Int, y1: Int, x2: Int, y2: Int) -> Double {
        return sqrt(pow(Double(x2 - x1), 2) + pow(Double(y2 - y1), 2))
    }
    
    private func correctByKalman (beaconsRangingPoint: [BeaconRangingPoint]) {
        for beacon in beaconsRangingPoint {
            if beacon.allDistances.count > kalmanSize {
                beacon.allDistances.remove(at: 0)
            }
            if beacon.allDistances.count == 0 {
                return
            }
            var rhat: Double = 0
            if beacon.previousDistanceCorrectedByKalman == 0 {
                rhat = beacon.distance
            } else {
                rhat = beacon.previousDistanceCorrectedByKalman
            }
            
            var p: Double = 1
            let noise:Double = 600
            
            for k in 0...(beacon.allDistances.count - 1) {
                let d = beacon.allDistances[k]
                let g = abs(p) < 1e-6 ? 1 : p / (p + noise)
                rhat = rhat + g * (d - rhat)
                p = (1 - g) * p
            }
            beacon.previousDistanceCorrectedByKalman = rhat
        }
    }
    
    private func correctByHeight(beacons: [BeaconRangingPoint]) {
        Logger.logMessage(message: "correctByHeight", level: .info)
        
        for beacon in beacons {
            let height: Double = Double(beacon.height) - userHeight
            if beacon.distance > height {
                beacon.distance = sqrt(pow(beacon.distance,2) - pow(height, 2))
            } else {
                beacon.distance = 1
            }
        }
        for beacn in beacons {
            Logger.logMessage(message: "minor: \(beacn.minor), distance: \(beacn.distance)", level: .info)
        }
    }
    
    private func saveToAllDistances (beacons: [BeaconRangingPoint]) {
        for beacon in beacons {
            beacon.allDistances.append(beacon.distance)
        }
    }
    
    private func getUserPoint (beacons: [BeaconRangingPoint]) {
        Logger.logMessage(message: "get user Point", level: .info)
        
        if beacons.count != 3  {
            Logger.logMessage(message: "wrong amount of closest beacons to find user location", level: .error)
            currentUserLocation.isLocated = false
            return
        }
        if beacons[0].allDistances.count < kalmanSize || beacons[1].allDistances.count < kalmanSize || beacons[2].allDistances.count < kalmanSize {
            Logger.logMessage(message: "not enough for kalman to get user location", level: .info)
            return
        }
        let RAp:Double = beacons[0].distance / ((beacons[0].distance + beacons[1].distance + beacons[2].distance) * 100)
        let RBp:Double = beacons[1].distance / ((beacons[0].distance + beacons[1].distance + beacons[2].distance) * 100)
        let RCp:Double = beacons[2].distance / ((beacons[0].distance + beacons[1].distance + beacons[2].distance) * 100)
        
        let ABPX = Double(beacons[0].x) + Double(beacons[1].x - beacons[0].x) / (RAp + RBp) * RAp
        let ABPY = Double(beacons[0].y) + Double(beacons[1].y - beacons[0].y) / (RAp + RBp) * RAp
        let ACPX = Double(beacons[0].x) + Double(beacons[2].x - beacons[0].x) / (RAp + RCp) * RAp
        let ACPY = Double(beacons[0].y) + Double(beacons[2].y - beacons[0].y) / (RAp + RCp) * RAp
        
        let Bnx: Double = Double(beacons[1].x - beacons[0].x)
        let Bny: Double = Double(beacons[1].y - beacons[0].y)
        let Cnx: Double = Double(beacons[2].x - beacons[0].x)
        let Cny: Double = Double(beacons[2].y - beacons[0].y)
        
        var y: Double = (Cny * ACPY + Cnx * ACPX - Cnx * Bnx * ABPX / Bnx - Cnx * Bny * ABPY / Bnx) / (Cny - Cnx * Bny / Bnx)
        var x: Double = (Bnx * ABPX - Bny * y + Bny * ABPY) / Bnx
        currentUserLocation.pointForDrawPerpendiculars = CGPoint(x: x, y: y)
        if !Geometry.isPointInTriangle(a: CGPoint(x: beacons[0].x, y: beacons[0].y),
                                       b: CGPoint(x: beacons[1].x, y: beacons[1].y),
                                       c: CGPoint(x: beacons[2].x, y: beacons[2].y),
                                       userPoint: CGPoint(x: x, y: y)) {
            let abpl: Double = Geometry.distanceBetweenPoints(x1: x, y1: y, x2: ABPX, y2: ABPY)
            let acpl: Double = Geometry.distanceBetweenPoints(x1: x, y1: y, x2: ACPX, y2: ACPY)
            
            if (abpl < acpl) {
                x = ABPX;
                y = ABPY;
            } else {
                x = ACPX;
                y = ACPY;
            }
        }
        if !isStart {
            isStart = true
            currentUserLocation.previousPoint = CGPoint(x: x, y: y)
        }
        currentUserLocation.abp = CGPoint(x: ABPX, y: ABPY)
        currentUserLocation.acp = CGPoint(x: ACPX, y: ACPY)
        kalman(point: CGPoint(x: x, y: y))
    }
    
    private func kalman(point: CGPoint) {
        Logger.logMessage(message: "start use kalman for userPoint", level: .info)
        currentUserLocation.listPoints.append(point)
        if currentUserLocation.listPoints.count > kalmanSize {
            currentUserLocation.listPoints.remove(at: 0)
        }
        var chatX:Double = Double(currentUserLocation.previousPoint!.x)
        var chatY:Double = Double(currentUserLocation.previousPoint!.y)
        
        var p: Double = 1
        let noise: Double = 100
        
        for k in 0...(currentUserLocation.listPoints.count - 1) {
            let d: Double = Double(currentUserLocation.listPoints[k].x)
            let g = abs(p) < 1e-6 ? 1 : p / (p + noise)
            chatX = chatX + g * (d - chatX)
            p = (1 - g) * p
        }
        
        for k in 0...(currentUserLocation.listPoints.count - 1) {
            let d: Double = Double(currentUserLocation.listPoints[k].y)
            let g = abs(p) < 1e-6 ? 1 : p / (p + noise)
            chatY = chatY + g * (d - chatY)
            p = (1 - g) * p
        }
        
        currentUserLocation.previousPoint = CGPoint(x: chatX, y: chatY)
        currentUserLocation.point = CGPoint(x: chatX, y: chatY)
        currentUserLocation.isLocated = true
        GeoLocation.userLocated = true
    }
}
