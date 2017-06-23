//
//  Route.swift
//  TeleRoamer
//
//  Created by Admin1 on 04.04.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import Foundation


class Route {

    fileprivate var _mapId: String!
    fileprivate var _floors: [Dictionary<String, Any>]!
    
    
    var mapId: String {
        if _mapId == nil{
            _mapId = ""
        }
        return _mapId
    }
    
    var floors: [Dictionary<String, Any>] {
        if _floors == nil{
            _floors = []
        }
        return _floors
    }
    init(dict: Dictionary<String, Any>) {
        
        if let mapId = dict["map"] as? String {
            self._mapId = mapId
        }
        
        if let floors = dict["floors"] as? [Dictionary <String,Any>] {
            self._floors = floors

        }

    }
    
}
