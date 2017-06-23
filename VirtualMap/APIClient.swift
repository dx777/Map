import Foundation
import Alamofire

var autofloor: Int!
var autoShopId: Int!
var shopName: String!

enum APIResult<T> {
    case Success(T?)
    case Failure(Error)
    case NOInternetConnection
}

protocol APIClient {
    var configuration: URLSessionConfiguration {get}
    var session: URLSession {get}
    
    func JSONTaskWithRequest (request: URLRequest,  completion: @escaping ([NSDictionary]?, HTTPURLResponse?, Error?) -> Void) ->URLSessionDataTask?
    
    func fetch<T> (request: URLRequest, parse: @escaping ([NSDictionary]) -> T?, completion: @escaping (APIResult<T>) -> Void)
}

extension APIClient {
    func JSONTaskWithRequest (request: URLRequest, completion: @escaping ([NSDictionary]?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTask? {
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard let HTTPResponse = response as? HTTPURLResponse else {
                completion(nil, nil, error)
                return
            }
            
            if data == nil {
                completion(nil, HTTPResponse, error)
            } else {
                switch HTTPResponse.statusCode {
                case 200:
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary]
                        Logger.logMessage(message: "json is \(String(describing: json))", level: .info)
                        completion(json, HTTPResponse, nil)
                    } catch let error as NSError {
                        completion(nil, HTTPResponse, error)
                    }
                default: Logger.logMessage(message: "Recieved HTTP Response: \(HTTPResponse.statusCode)" , level: .error)
                }
            }
        }
        return task
    }
    
    func fetch<T> (request: URLRequest, parse: @escaping ([NSDictionary]) -> T?, completion: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWithRequest(request: request) {
            (json, response, error) in
            
            DispatchQueue.main.async {
                
                guard let json = json else {
                    completion(APIResult.NOInternetConnection)
                    return
                }
                print("VAL \(json)")
                
                var jsonContent = [json[0]]
                let shopId = jsonContent[0]["id"] as? Int
                autoShopId = shopId
                MapViewController.currentShop = autoShopId
                let floor = jsonContent[0]["floor"] as? String
                autofloor = Int(floor!)
                let placename = jsonContent[0]["place_name"] as? String
                shopName = placename
                autofloor = Int(floor!)
                MapViewController.currentFloor = autofloor
                MapViewController.currentUserFloor = autofloor
                let floorid = Int(floor!)
                MapViewController.autodetect = true
                
                
                var val: NSDictionary?
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "LoggedIn"), object: nil, queue: nil) { (notification) in
                    
                    print("FOUND IT EXC")
                    
                    self.getFloor(shop: shopId!, floor: floorid!, onCompletion: { dict in
                        val = dict
                        let value = parse([val!])
                        
                        if value == nil {
                            completion(APIResult.Failure(error!))
                        } else {
                            completion(APIResult.Success(value))
                        }
                        
                    })
                    
                }
                
                self.getFloor(shop: shopId!, floor: floorid!, onCompletion: { dict in
                    val = dict
                    let value = parse([val!])
                    
                    if value == nil {
                        completion(APIResult.Failure(error!))
                    } else {
                        completion(APIResult.Success(value))
                    }
                    
                })
                
                
            }
        }
        task!.resume()
    }
    
    func getFloor(shop: Int, floor: Int, onCompletion: @escaping (_ floorDict: NSDictionary) -> ()) {
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        
        
        let headers: HTTPHeaders = [
            "X-Client-Id": "\(uuid)",
            "X-Client-Os": "ios",
        ]
        let url = "https://www.teleroamer.com/api/v1/maps/\(shop)/floors/\(floor)"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let result = response.result
            
            if let floorDict = result.value as? NSDictionary {
                MapViewController.switchingMode = true
                // let result = MapDataParsing.jsonParse(json: [floorDict])
                onCompletion(floorDict)
            }
            
            
        }
        
        
    }
}
