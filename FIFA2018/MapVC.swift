//
//  MapVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 13.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import NMAKit
import Alamofire
import ObjectMapper


class MapVC: UIViewController, CLLocationManagerDelegate, NMARouteManagerDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var goToHome: UIButton!
    @IBOutlet weak var mapView: NMAMapView!
    var clusters = [ClusterModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        goToHome.layer.cornerRadius = 25
        
        mapView.useHighResolutionMap = true
        mapView.positionIndicator.isVisible = true
        mapView.zoomLevel = 13.2
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: 55.716542, longitude: 37.553947), animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        
        if NMAPositioningManager.shared().startPositioning() {
            NotificationCenter.default.addObserver(self, selector: #selector(positionDidUpdate), name: .NMAPositioningManagerDidUpdatePosition, object: NMAPositioningManager.shared())
            
        }
        
        loadData()
    }
    
    @objc func loadData () {
        let params:Parameters = ["latitude": locationManager.location?.coordinate.latitude ?? 0, "longitude": locationManager.location?.coordinate.longitude ?? 0]
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getClusters")!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                //print(params)
                if let JSON = response.result.value as? [String:AnyObject] {
                    let errorCode = JSON["errorCode"] as! Int
                    if errorCode == 0 {
                        self.clusters = Mapper<ClusterModel>().mapArray(JSONObject: JSON["result"])!
                        for cluster in self.clusters {
                            let circle = NMAMapCircle.init(coordinates: NMAGeoCoordinates.init(latitude: cluster.Latitude, longitude: cluster.Longitude), radius: Double(cluster.Count))
                            circle.fillColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: CGFloat(cluster.Alpha))
                            self.mapView.add(circle)
                        }
                    } else {
                        self.showAlertMessage(text: "Чемпионат не найдет", title: "Ошибка")
                    }
                }
            case .failure(let error):
                print("Error \(error)")
                //fail(error as NSError)
            }
        }
    }

    @objc func positionDidUpdate () {
        let position = NMAPositioningManager.shared().currentPosition
        mapView.set(geoCenter: (position?.coordinates)!, animation: .linear)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    @IBAction func goToMyLocationAction(_ sender: Any) {
        let position = NMAPositioningManager.shared().currentPosition
        mapView.set(geoCenter: (position?.coordinates)!, animation: .linear)
    }
    
    @IBAction func goToHomeAction(_ sender: Any) {
        let params:Parameters = ["latitude": locationManager.location?.coordinate.latitude ?? 0, "longitude": locationManager.location?.coordinate.longitude ?? 0]
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getWay")!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
                    let data = Mapper<MetroModel>().map(JSONObject: JSON["result"])
                    let routeManager = NMARouteManager.shared()
                    routeManager.delegate = self
                    var stops = [NMAGeoCoordinates]()
                    let geoCoord1 = NMAPositioningManager.shared().currentPosition?.coordinates
                    let geoCoord2 = NMAGeoCoordinates(latitude: (data?.Latitude)!, longitude: (data?.Longitude)!)
                    stops.append(geoCoord1!)
                    stops.append(geoCoord2)
                    print(stops)
                    let routingMode = NMARoutingMode.init(routingType: .fastest, transportMode: .pedestrian, routingOptions: 0)
                    routeManager.calculateRoute(stops: stops, mode: routingMode!)
                    
                    
                    
//                    //                    print(response.response)
//                    //                    print(response.request)
//                    //                    print(response.result.value)
//                    let data = Mapper<GeoLocation>().mapArray(JSONObject: JSON["result"])
//                    for geo in data! {
//                        let marker = NMAMapMarker.init(geoCoordinates: NMAGeoCoordinates.init(latitude: geo.Latitude, longitude: geo.Longitude))
//                        marker.title = "te"
//                        marker.icon = #imageLiteral(resourceName: "Pin")
//                        self.mapView.add(marker)
//                    }
                }
            case .failure(let error):
                print("Error \(error)")
                //fail(error as NSError)
            }
        }
    }

    func routeManagerDidCalculate(_ routeManager: NMARouteManager, routes: [NMARoute]?, error: NMARouteManagerError, violatedOptions: [NSNumber]?) {
        print(error.rawValue)
        //if error == nil && routes != nil && (routes?.count)! > 0 {
        OperationQueue.main.addOperation {
            
            let route = routes![0]
            let mapRoute = NMAMapRoute.init(route: route)
            self.mapView.add(mapRoute)
        }
//        } else if error != nil {
//
//        }
    }
    
}
