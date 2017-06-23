import Foundation

class BluetoothManagerDelegate: NSObject, ABBluetoothManagerDelegate {
    
    private let discoveredBeacons: (_ arrayOfBeacons: [ABBeacon]) -> ()
  
    init(discoveredBeacons: @escaping (_ arrayOfBeacons: [ABBeacon]) -> ()) {
        self.discoveredBeacons = discoveredBeacons
    }
    
    func beaconManager(_ manager: ABBluetoothManager!, didDiscover beacon: ABBeacon!) {
        Logger.logMessage(message: "found one beacon", level: .info)
    }
    
    func beaconManager(_ manager: ABBluetoothManager!, didDiscoverBeacons beacons: [Any]!) {
        Logger.logMessage(message: "found beacons: \(beacons)", level: .info)
        
        if beacons.count == 0 {
            Logger.logMessage(message: "empty array of discovered becons", level: .warn)
        }
        var arrayOfABBeacons: [ABBeacon] = []
        for element in beacons {
            if let elementAsABBeacon = element as? ABBeacon {
                arrayOfABBeacons.append(elementAsABBeacon)
            } else {
                Logger.logMessage(message: "can not convert element to  ABBeacon class", level: .warn)
            }
        }
        discoveredBeacons(arrayOfABBeacons)
    }
}
