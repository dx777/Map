//
//  Request.swift
//  TeleRoamer
//
//  Created by Admin on 16.11.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation

class Request {
   private static  let baseURL = URL(string: "https://www.teleroamer.com/api/v1/maps/search")!
 
    static func getPathForRequest(path: String) -> URLRequest {
        var request = URLRequest(url: baseURL)
        let uuid = UIDevice.current.identifierForVendor!.uuidString

        request.httpMethod = "POST"
        let postString = path
        print ("STRING \(postString)")
        
        request.httpBody = postString.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("\(uuid)", forHTTPHeaderField: "X-Client-Id")
        request.addValue("ios", forHTTPHeaderField: "X-Client-Os")

        return request
    }
    
}
