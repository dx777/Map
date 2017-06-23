import Foundation
var isneedreview: Bool = false

class MapDataParsing {
    
    //TODO: handle invalid JSON data errors
    static func jsonParse(json: [NSDictionary]) -> Floor? {
        
        
        
        
        var doors: [Door] = []
        var walls: [Wall] = []
        var beacons: [Beacon] = []
        var floorContent: [NSDictionary]?
        
        if !MapViewController.switchingMode {
            floorContent = NSDictionaryUtility.getChildren(json: json[0], parent: "floors")
            
        } else {
            floorContent = [json[0]]
            
        }
        
        if let floorContent = floorContent {
            
            let beaconContent = NSDictionaryUtility.getChildren(json: floorContent[0], parent: "beacons")
            
            
            if let beaconContent = beaconContent{
                for beacon in beaconContent {
                    beacons.append(Beacon(x: beacon["x"] as! Int,
                                          y: beacon["y"] as! Int,
                                          name: beacon["name"] as! String,
                                          heightAboveTheFloor: Int(beacon["heightAboveTheFloor"] as! String)!,
                                          uuid: UUID(uuidString: beacon["uuid"] as! String)!,
                                          major: Int(beacon["major"] as! String)!,
                                          minor: Int(beacon["minor"] as! String)!,
                                          id: beacon["id"] as! String))
                }
            }
            
            if let ifneedreview = floorContent[0]["is_need_review"] as? Bool {
                isneedreview = ifneedreview
            }
            
            

        
            
            
            let wallContent = NSDictionaryUtility.getChildren(json: floorContent[0], parent: "walls")
            
            
            if let wallContent = wallContent {
                for wall in wallContent {
                    walls.append(Wall(x1: wall["x1"] as! Int,
                                      x2:  wall["x2"] as! Int,
                                      y1:  wall["y1"] as! Int,
                                      y2:  wall["y2"] as! Int,
                                      id:  wall["id"] as! String))
                    if let doorContent = NSDictionaryUtility.getChildren(json: wall, parent: "doors") {
                        for door in doorContent {
                            doors.append(Door(distanceStart: door["distanceStart"] as! Int,
                                              distanceEnd: door["distanceEnd"] as! Int,
                                              owner: door["owner"] as! String,
                                              id: door["id"] as! String))
                        }
                    }
                }
            }
        }
        
        return Floor(walls: walls, doors: doors, beacons: beacons, isneedreview: isneedreview)
    }
}
