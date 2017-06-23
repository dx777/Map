import Foundation

class BeaconManagerDelegate: NSObject, ABBeaconManagerDelegate {
    private let gotRangedBeacons: (_ beaconRangingData: [BeaconRangingData]) -> ()
    
    init(gotRangedBeacons: @escaping (_ beaconRangingData: [BeaconRangingData]) -> ()) {
        self.gotRangedBeacons = gotRangedBeacons
    }
    
    func beaconManager(_ manager: ABBeaconManager!, didRangeBeacons beacons: [Any]!, in region: ABBeaconRegion!) {
        Logger.logMessage(message: "did ranged beacons: \(beacons)", level: .info)
        var beaconRangingData: [BeaconRangingData] = []
        for element in beacons {
            if let elementAsABBeacon = element as? ABBeacon {
                Logger.logMessage(message: "Distance is \(elementAsABBeacon.distance)", level: .info)
                beaconRangingData.append(BeaconRangingData(uuid: elementAsABBeacon.proximityUUID, major: Int(elementAsABBeacon.major), minor: Int(elementAsABBeacon.minor), distance: elementAsABBeacon.distance as! Double))
            } else {
                Logger.logMessage(message: "can not convert to ABBeacon", level: .error)
            }
        }
        gotRangedBeacons(beaconRangingData)
    }
}
