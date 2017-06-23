import Foundation

final class CurrentAPIClient: APIClient {
    private var request: URLRequest
  
    init(request: URLRequest) {
        self.request = request
    }
    let configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    func fetchCurrentFloor(completion: @escaping (APIResult<Floor>) -> Void) {
        MapViewController.switchingMode = true
        fetch(request: request, parse: MapDataParsing.jsonParse, completion: completion)
    }
}






