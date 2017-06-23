import Foundation
class BeaconDelegate: NSObject, ABBeaconDelegate {
    private let gotBeaconInfo: (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber ) -> ()
    private let didBeaconDisconnect: () -> ()
    
    init(gotBeaconInfo: @escaping (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> (), didBeaconDisconnect: @escaping () -> ()) {
        self.gotBeaconInfo = gotBeaconInfo
        self.didBeaconDisconnect = didBeaconDisconnect
    }
    
    func beaconDidConnected(_ beacon: ABBeacon!, withError error: Error!) {
        Logger.logMessage(message: "beaconn did connected, beacon: \(beacon)", level: .info)
        gotBeaconInfo(beacon.proximityUUID, beacon.peripheral.name!, beacon.major, beacon.minor)
        
    }
    func beaconDidDisconnect(_ beacon: ABBeacon!, withError error: Error!) {
        Logger.logMessage(message: "beaconn did DISconnected, beacon: \(beacon)", level: .info)
        didBeaconDisconnect()
    }
    
}
 
