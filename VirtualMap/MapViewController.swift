import UIKit
import MapKit
import CoreLocation
import Alamofire
import DropDown

class MapViewController: UIViewController  {
    
    fileprivate var scaleView: CGFloat = 1
    fileprivate var rotateView: CGFloat = 0
    fileprivate var anchorPoint = CGPoint(x: 0.5, y: 0.5)
    fileprivate let gestureRecognizerDelegate = GestureRecognizerDelegate()
    fileprivate let bluetoothManager = ABBluetoothManager()
    fileprivate let line = CAShapeLayer()
    
    
    static var currentUserFloor: Int?
    static var currentShop: Int?
    static var currentFloor: Int?
    static var autodetect = false
    static var currentUserLoc: CGPoint?
    static var arrayOfPointsToDraw = [CGPoint]()
    static var switchingMode = false
    static var onApplicationStarted = false
    
    var locationManager: CLLocationManager = CLLocationManager()
    var button: UIButton!
    var floorsArr = ["empty"]
    var pinImage = UIImageView()
    let dropDown = DropDown()
    
    @IBOutlet weak var mapView: MapView!
    @IBOutlet var pinchGestureRecognizer: UIPinchGestureRecognizer!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet var rotateGestureRecognizer: UIRotationGestureRecognizer!
    @IBOutlet weak var chooseFloorView: UIView!
    @IBOutlet weak var chooseFloorBtn: UIButton!
    @IBOutlet weak var distanceLbl: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
            
            if !MapViewController.onApplicationStarted {
                ApplicationManager.sharedInstance.onApplicationStart()
            }
            ApplicationManager.sharedInstance.gotFloorData = drawFloor

        
    }
    
    override func viewDidLoad() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeDistance(_:)), name: NSNotification.Name(rawValue: "ChangeDistance"), object: nil)


        
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.initiateRoute(touch:)))
        tap.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tap)
        
        


        dropDown.anchorView = self.chooseFloorView
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.width = 100
        dropDown.dataSource = ["Test", "Test", "Test"]
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.chooseFloorBtn.setTitle("\(index + 1) Этаж", for: .normal)
            if MapViewController.currentShop != nil {
                if MapViewController.currentFloor != index + 1 {
                    self.downloadFloor(shop: MapViewController.currentShop!, floor: index + 1)
                }
            }
        }
        
        
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onOrientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.panGestureRecognizer.delegate = gestureRecognizerDelegate
        self.pinchGestureRecognizer.delegate = gestureRecognizerDelegate
        self.rotateGestureRecognizer.delegate = gestureRecognizerDelegate
        
        
    }
    

    
    
    func initiateRoute(touch: UITapGestureRecognizer) {
        if autoShopId == MapViewController.currentShop {
            if GeoLocation.userLocated {
                let touchPoint = touch .location(in: self.mapView)
                
                let unScaledTappedPoint = unscaleTappedPoint(tappedPoint: touchPoint, scale: CoordinatesConverter.scale!, offsetX: CoordinatesConverter.offsets.offsetX, offsetY: CoordinatesConverter.offsets.offsetY)
                
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                //                    self.getRoute(tappedPoint: unScaledTappedPoint, shopId: MapViewController.currentShop!, floor: MapViewController.currentFloor!)
                //                })
                
                self.getRoute(tappedPoint: unScaledTappedPoint, shopId: MapViewController.currentShop!, floor: MapViewController.currentFloor!, fromItem: false, x: nil, y: nil, itemFloor: nil)
                
                
                
//                                pinImage.removeFromSuperview()
//                                let pin = UIImage(named: "pin")
//                                pinImage.removeFromSuperview()
//                                pinImage.image = pin
//                                pinImage.frame = CGRectMake(touchPoint.x, touchPoint.y, 40, 40)
//                                pinImage.contentMode = UIViewContentMode.scaleAspectFill
//                                self.mapView.addSubview(pinImage)
//                                pinImage.center = touchPoint
                
            }
            
        }
        
        
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func unscaleTappedPoint (tappedPoint: CGPoint, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        return CGPoint(x: Int(CGFloat(tappedPoint.x - offsetX) / scale) , y: Int(CGFloat(tappedPoint.y - offsetY) / scale))
    }
    
    func scaleCoordinate (coordinate: CGPoint, scale: CGFloat, offsetX: CGFloat, offsetY: CGFloat) -> CGPoint {
        return CGPoint(x: Int(CGFloat(coordinate.x) * scale + offsetX) , y: Int(CGFloat(coordinate.y) * scale + offsetY))
    }
    
    
    func showDropdown() {
        dropDown.show()
    }
    
    func drawFloor (floor: Floor) {
        
        
        
        if autoShopId == MapViewController.currentShop && autofloor == MapViewController.currentFloor {
            ApplicationManager.sharedInstance.currentUserPoint = drawCurrentUserPoint
            
        } else {
            ApplicationManager.sharedInstance.currentUserPoint = removeCurrentUserPoint
        }
        
        if MapViewController.autodetect {
            if autofloor != nil, autoShopId != nil {
                self.downloadFloorsQty(floor: autofloor, onCompletion: { floors in
                    self.createFloorsArr(qty: floors)
                    self.chooseFloorBtn.setTitle("\(autofloor!) Этаж", for: .normal)
                    self.chooseFloorBtn.addTarget(self, action: #selector(self.showDropdown), for: .touchUpInside)
                    self.dropDown.dataSource = self.floorsArr
                    print("HERE \(self.floorsArr)")
                    
                    
                    
                    
                    
                    
                })
                
            }
            
            
        }
        
        
        mapView.setFloor(currentFloor: floor)
        mapView.setNeedsDisplay()
    }
    
    func drawCurrentUserPoint(currentUserPoint: CurrentUserLocation, beaconRangingData: [BeaconRangingPoint]) {
        MapViewController.currentUserLoc = userPoint
        
        mapView.setUserPoint(currentUserPoint: currentUserPoint, beaconRangingData: beaconRangingData)
        mapView.setNeedsDisplay()
    }
    
    
    
    func removeCurrentUserPoint(currentUserPoint: CurrentUserLocation, beaconRangingData: [BeaconRangingPoint]) {
        mapView.removeUserPoint(currentUserPoint: currentUserPoint, beaconRangingData: beaconRangingData)
        mapView.setNeedsDisplay()
        
    }
    

    
    
    
    private func setAnchor(point : CGPoint) {
        let anchor = CGPoint(x: point.x / mapView.bounds.width, y: point.y / mapView.bounds.height)
        mapView.layer.anchorPoint = CGPoint(x: anchor.x, y: anchor.y)
        let translationX = (mapView.bounds.width * (anchor.x - anchorPoint.x)) * scaleView
        let translationY = (mapView.bounds.height * (anchor.y - anchorPoint.y)) * scaleView
        let offsetX = translationX * CGFloat(cosf(Float(rotateView))) - translationY * CGFloat(sinf(Float(rotateView)))
        let offsetY = translationX * CGFloat(sinf(Float(rotateView))) + translationY * CGFloat(cosf(Float(rotateView)))
        mapView.layer.position = CGPoint(x: mapView.layer.position.x + offsetX,
                                         y: mapView.layer.position.y + offsetY)
        anchorPoint = anchor
    }
    
    private func showAlert(title: String, message: String?, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) {
            alertAction in
            ApplicationManager.sharedInstance.onApplicationStart()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func onOrientationChanged() {
        self.mapView.setNeedsDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    
    
    func createFloorsArr(qty: Int) {
        var Arr = [String]()
        
        var x = 1
        while x <= qty {
            let floor = "\(x) Этаж"
            Arr.append(floor)
            x = x + 1
        }
        floorsArr = Arr
    }
    
    
    
    func getRoute(tappedPoint: CGPoint?, shopId:Int, floor: Int, fromItem: Bool, x: Int?, y: Int?, itemFloor: Int?) {
        
        let uuid = UIDevice.current.identifierForVendor!.uuidString
        var url = ""
        
        let headers: HTTPHeaders = [
            "X-Client-Id": "\(uuid)",
            "X-Client-Os": "ios"
        ]
        
        
        
        if CoordinatesConverter.unScaledUserPoint != nil && MapViewController.currentUserFloor != nil {
            
            if fromItem {
                
                url = "https://www.teleroamer.com/api/v1/maps/path?subfloor=1&yto=\(y!)&y=\(Int(CoordinatesConverter.unScaledUserPoint!.y))&map=\(shopId)&floorto=\(itemFloor!)&mapto=\(shopId)&x=\(Int(CoordinatesConverter.unScaledUserPoint!.x))&subfloorto=1&floor=\(MapViewController.currentUserFloor!)&xto=\(x!)"
                
                
            } else {
                url = "https://www.teleroamer.com/api/v1/maps/path?subfloor=1&yto=\(Int((tappedPoint?.y)!))&y=\(Int(CoordinatesConverter.unScaledUserPoint!.y))&map=\(shopId)&floorto=\(floor)&mapto=\(shopId)&x=\(Int(CoordinatesConverter.unScaledUserPoint!.x))&subfloorto=1&floor=\(MapViewController.currentUserFloor!)&xto=\(Int((tappedPoint?.x)!))"
            }
            
        }

        
        
        print(url)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, Any>{
                
                let route = Route(dict: dict)
                
                pointsDict = [:]
                for floor in route.floors {
                    let name = floor["name"] as? String
                    let points = floor["points"] as? [Dictionary<String, Any>]
                    pointsDict[name!] = points
                    if (points?.isEmpty)! {
                        print("EMPTY")
                        let alert = UIAlertController(title: "Ошибка", message: "Маршрут не найден", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    self.getPointsToDraw()
                    
                }
                
                
            }
            
        }
    }
    
    
    
    func getPointsToDraw() {
        MapViewController.arrayOfPointsToDraw = []
        let currentPoints = pointsDict["\(MapViewController.currentFloor!)"]
        
        
        if currentPoints != nil && (currentPoints?.count)! > 0{
            for point in currentPoints! {
                let x = point["x"] as? Int
                let y = point["y"] as? Int
                let coordinate = CGPoint(x: x!, y: y!)
                
                var scaledCoordinate = scaleCoordinate(coordinate: coordinate, scale: CoordinatesConverter.scale, offsetX: CoordinatesConverter.offsets.offsetX, offsetY: CoordinatesConverter.offsets.offsetY)
                
                if(MapViewController.arrayOfPointsToDraw.count == 0) {
                    if autoShopId == MapViewController.currentShop && autofloor == MapViewController.currentFloor {
                        if((MapViewController.currentUserLoc) != nil) {
                            scaledCoordinate = MapViewController.currentUserLoc!
                        }
                    }
                }
                MapViewController.arrayOfPointsToDraw.append(scaledCoordinate)
            }
        }
    }
    
    func changeDistance(_ notification: NSNotification) {
        if(pointsDict.isEmpty) {
            self.distanceLbl.text = ""
        } else {
            if let distance = notification.userInfo?["distance"] as? Double {
                self.distanceLbl.text = String(format: "%li м", Int(distance))
            }
        }
    }
    
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }


    
    func downloadFloor(shop: Int, floor: Int) {
        MapViewController.currentFloor = floor
        MapViewController.currentShop = shop
        getPointsToDraw()
        
        
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
                let result = MapDataParsing.jsonParse(json: [floorDict])
                MapViewController.autodetect = false
                self.drawFloor(floor: result!)
                

            }
            
            
        }
        
        
    }
    
    func downloadFloorsQty(floor: Int, onCompletion: @escaping (_ totalFloors: Int) -> ()) {
        let url = "https://teleroamer.com/api/v1/maps/\(floor)/floors"
        Alamofire.request(url).responseJSON { response in
            
            let result = response.result
            if let dict = result.value as? Dictionary<String, Any>{
                if let floorsList = dict["floors"] as? Array<String> {
                    var totalFloors = 0
                    for _ in floorsList {
                        totalFloors = totalFloors + 1
                    }
                    onCompletion(totalFloors)
                    

                    
                }
            }
            
            
        }
        
        
    }
    @IBAction func resetRoute(_ sender: Any) {
        pointsDict = [:]
        MapViewController.arrayOfPointsToDraw = []
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: mapView)
            if recognizer.view != nil {
                let offsetX = translation.x * CGFloat(cosf(Float(rotateView))) - translation.y * CGFloat(sinf(Float(rotateView)))
                let offsetY = translation.x * CGFloat(sinf(Float(rotateView))) + translation.y * CGFloat(cosf(Float(rotateView)))
                mapView.center = CGPoint(x:mapView.center.x + offsetX * scaleView,
                                         y:mapView.center.y + offsetY * scaleView)
            }
            recognizer.setTranslation(CGPoint(x: 0, y: 0), in: mapView)
        
        
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
            if recognizer.view != nil {
                setAnchor(point: recognizer.location(in: mapView))
                mapView.transform = mapView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                scaleView = recognizer.scale * scaleView
                recognizer.scale = 1
            }
            
            
        
    }
    
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
            if recognizer.view != nil {
                setAnchor(point: recognizer.location(in: mapView))
                mapView.transform = mapView.transform.rotated(by: recognizer.rotation)
                rotateView = rotateView + recognizer.rotation
                recognizer.rotation = 0
            }
        
        
    }
}
