//
//  TestBeaconManager.swift
//  TeleRoamer
//
//  Created by Admin on 25.11.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
class TestBeaconManager: BeaconManagerProtocol {
    var count = 0

    let fullArray =  [
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 25.274997063702618),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.99484250318941),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 2.742636826811269),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 12.91549665014884),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 24.48436746822227),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 24.48436746822227)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 5.274997122631299),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.523585202739491),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 6.649913098462197),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 14.3268036931343),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 15.04849247301817),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 17.24218368530273),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: 46.4158883361278),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 52.74997063702619),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: 52.74997063702619)
        ],
        
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 4.997137341348794),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 6.231530747652068),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.859545065069174),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.92220903973969),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 15.40342533888936),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 16.43848637335984),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: 46.41588949114857),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 51.62722180503238),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: 52.74996966642266)
        ],
        
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 14.882408516906403),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.654347750665963),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.826190104536014),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.58258226888883),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 5.84585830798029),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 18.60584030776478)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 10.125149796340496),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.364561550891357),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.806516701730049),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.35203565779928),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 3.10547147823727),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 20.28680226395108)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.187716408707479),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 25.297628236208429),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.7934137795954),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.67022172677906),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 1.19139766000168),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 21.28743212613293),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 53.38346259534384)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.067384760953106),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 26.426958353282904),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.591710947133705),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.70570199685948),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 1.25927188798656),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 54.00416503468768)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 4.980018541272646),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 5.397144433265082),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.617250224022961),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.94676607903516),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 14.31434477981315),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 25.86721736586306)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 4.914001320353072),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 5.374393221090538),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.637402200979014),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.94263398442431),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 13.56467994963037),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.1003300915606)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 4.975406128921775),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 5.356497501305009),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.798853141803567),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.7184014728402),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 12.99217279843987),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.2925021034174),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 56.43234261977142)
        ],
    
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.130297734436715),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 5.45747412872),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.936130322953304),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.30535726115136),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 12.53943675227831),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.45399314384172),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 56.11008774974799),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: 62.76459111139874)
        ],
       
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.361214765335665),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.906854175164093),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 11.73981329915958),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 12.17307241990363),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.59163967455122),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 55.2033995791546),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: 61.18523447273083)
        ],
     
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.564655573150199),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 5.746517358584288),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.882520616450524),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 11.2886476819798),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 11.87042337788171),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 27.98496747923837),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 55.53585031167754),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: 59.83789425903384)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.742403751842155),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.102938304155045),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 8.00239536851109),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 10.92062610363504),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 11.80905929335185),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 27.96952209772054),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 57.40027907804759),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: 57.98642732646363)
        ],
      
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.896166013253744),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.377181525114467),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 7.964482476668676),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 10.6163564528865),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 11.75567883827253),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 27.60393827613952),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: 56.40391780415145),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 56.45595741890057)
        ],
        
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 5.912089894608529),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.586426131339992),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 8.418863161614082),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 10.53891097559389),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 11.87924229779207),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 27.2896219767976),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: 55.62150233506479),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: 55.62915849466361),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: 59.45107904568198)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 6.24422350843404),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.317160214769364),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 9.125130410697103),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 11.02479015823173),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 12.52885939140231),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 27.01627223991252)
        ],
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.116654655600771),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 6.328533760391025),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 10.10761849399604),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 11.60396735005926),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 13.15994523245163),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.77665663274059)
        ],
    
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.33324488382031),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 6.516234296215512),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 10.96666318240765),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.46466381711405),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 13.76749086029146),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.56489104494806)
        ],
     
        [
            
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: 4.722682851031209),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.276553710839376),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 11.9839356765039),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 12.98493375825695),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 14.59312300560652),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.37656085610987)
        ],
    
        [
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 14725, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11141, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 10373, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12165, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 13701, distance: -1),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 15749, distance: 6.093558029657041),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 11653, distance: 13.15816469482786),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 16005, distance: 13.16011919933638),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 12421, distance: 15.40095272240488),
            BeaconRangingData(uuid: UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, major: 1, minor: 19589, distance: 26.74538957706556)
        ]
    ]
    
    private var gotMaxBeaconInfo: (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> Void = {(uuid,name, major, minor) -> Void in }
    private var gotRangedBeaconInfo: (_ rangingBeacons: [BeaconRangingData]) -> Void = {rangingBeacons -> Void in }
    
    
    init() {
      
    }
    
    func startGettingAllBeacons() {
        getAllBeacons()
    }
    private func getAllBeacons() {
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "StartAprilBeconsDiscovery", level: .info)
        gotMaxBeaconInfo(UUID(uuidString: "B5B182C7-EAB1-4988-AA99-B5C1517008D9")!, "abeacon_8541", 1, 16773)
    }
    
    private func discoveredBeacons (_ arrayOfBeacons: [ABBeacon]) -> () {
        
    }
    
    private func gotBeaconInfo(_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) {
        
    }

    private func didBeaconDisconnect() {
   
    }
    
    func setGotMaxBeaconInfoFunc(gotMaxBeaconInfo: @escaping (_ uuid: UUID, _ name: String, _ major: NSNumber, _ minor: NSNumber) -> ()) {
        self.gotMaxBeaconInfo = gotMaxBeaconInfo
    }
    
    func startRangeBeacons(UUIDs: [UUID]) {
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "StartRangingBecons uuids : \(UUIDs)", level: .info)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerToGetRangedBeaconInfo), userInfo: nil, repeats: true)
        
    }
    @objc private func timerToGetRangedBeaconInfo () {
        Logger.logMessageWithClassName(className: NSStringFromClass(type(of: self)), message: "timerToGetRangedBeaconInfo", level: .info)
        if count < fullArray.count {
            gotRangedBeaconInfo(fullArray[count])
            count += 1
        }
        
        if count == fullArray.count {
            count = 0
                    }
    }
    
    private func gotRangedBeacons(_ beaconRangingData: [BeaconRangingData])  {
       
    }
    
    func setGotRangedBeaconsFunc(gotRangedBeaconsInfo: @escaping (_ rangingBeacons: [BeaconRangingData]) -> ()) {
        self.gotRangedBeaconInfo = gotRangedBeaconsInfo
    }
}
