import Foundation
import UIKit

var tabclosed = false
class BeaconManager: BeaconManagerProtocol {
    private var hadConnectedToBeacon = false
    private let bluetoothManager = ABBluetoothManager()
    private let rangeManager = ABBeaconManager()
    private var bluetoothDelegate: BluetoothManagerDelegate? = nil
    private var abBeaconDelegate: BeaconDelegate? = nil
    private var rangeManagerDelegate: BeaconManagerDelegate? = nil
    private var gotMaxBeaconInfo: (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> Void = {(uuid,name, major, minor) -> Void in }
    private var gotRangedBeaconInfo: (_ rangingBeacons: [BeaconRangingData]) -> Void = {rangingBeacons -> Void in }
    private var timerToStartGetAllBeacons: Timer = Timer()
    private let getAllBeaconsInterval:TimeInterval = 10
    
    init() {
        bluetoothDelegate = BluetoothManagerDelegate(discoveredBeacons: discoveredBeacons)
        self.bluetoothManager.delegate = bluetoothDelegate
        abBeaconDelegate = BeaconDelegate(gotBeaconInfo: gotBeaconInfo, didBeaconDisconnect: didBeaconDisconnect)
        rangeManagerDelegate = BeaconManagerDelegate(gotRangedBeacons: gotRangedBeacons)
        self.rangeManager.delegate = rangeManagerDelegate
    }
    
    private func didBeaconDisconnect() {
       // getAllBeacons()
    }
    
    func setGotRangedBeaconsFunc(gotRangedBeaconsInfo: @escaping (_ rangingBeacons: [BeaconRangingData]) -> ()) {
        self.gotRangedBeaconInfo = gotRangedBeaconsInfo
    }
    
    private func gotRangedBeacons(_ beaconRangingData: [BeaconRangingData])  {
        if beaconRangingData.isEmpty {
            Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "no beacons after ranginng", level: .warn)
            return
        }
        gotRangedBeaconInfo(beaconRangingData)
    }
    
    func setGotMaxBeaconInfoFunc(gotMaxBeaconInfo: @escaping (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> ()) {
        self.gotMaxBeaconInfo = gotMaxBeaconInfo
    }
    
    func startGettingAllBeacons() {
        timerToStartGetAllBeacons = Timer.scheduledTimer(timeInterval: getAllBeaconsInterval, target: self, selector: #selector(getAllBeacons), userInfo: nil, repeats: true)
        timerToStartGetAllBeacons.fire()
    }
    
    @objc private func getAllBeacons() {
        if !tabclosed {
            Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "startAprilBeaconsDiscovery", level: .info)
            bluetoothManager.startAprilBeaconsDiscovery()
            
        }

    }
    
    func startRangeBeacons(UUIDs: [UUID]) {
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "StartRangingBecons uuids : \(UUIDs)", level: .info)
        
        for uuid in UUIDs {
            let proximityUUID = uuid
            let regionIdentifier = String(describing: uuid).capitalized
            let region = ABBeaconRegion(proximityUUID: proximityUUID, identifier: regionIdentifier)
            rangeManager.startRangingBeacons(in: region)
        }
    }
    
    private func discoveredBeacons (_ arrayOfBeacons: [ABBeacon]) -> () {
        
        if arrayOfBeacons.count > 0 {
            Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "discovered beacons is found, now StopAprilBeaconDiscovery", level: .info)
           
            bluetoothManager.stopAprilBeaconDiscovery()
        } else {
            Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "discovered beacons is null", level: .warn)
            return
        }
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "All beacons: \(arrayOfBeacons)", level: .info)
        let beaconWithMaxRssi = arrayOfBeacons.reduce(arrayOfBeacons[0]) {
            $0.rssi > $1.rssi ? $0 : $1
        }
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "MAX rssi beacon: \(beaconWithMaxRssi)", level: .info)
        beaconWithMaxRssi.delegate = abBeaconDelegate
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "connect to BEacon with Max Rssi", level: .info)
        beaconWithMaxRssi.connectToBeacon()
    }
    
    private func gotBeaconInfo(_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) {
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "beacon info: \(uuid), \(name), \(major), \(minor)", level: .info)
        if hadConnectedToBeacon {
             Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "func gotBeaconInfo had already recieved beacon info", level: .info)
            return
        }
        hadConnectedToBeacon = true
        timerToStartGetAllBeacons.invalidate()
        gotMaxBeaconInfo(uuid, name, major, minor)
    }
}
