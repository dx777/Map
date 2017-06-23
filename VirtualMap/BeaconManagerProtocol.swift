import Foundation
protocol  BeaconManagerProtocol {
   
    func setGotRangedBeaconsFunc(gotRangedBeaconsInfo: @escaping (_ rangingBeacons: [BeaconRangingData]) -> ())
    func setGotMaxBeaconInfoFunc(gotMaxBeaconInfo: @escaping (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> ())
    func startGettingAllBeacons()
    func startRangeBeacons(UUIDs: [UUID])
}
