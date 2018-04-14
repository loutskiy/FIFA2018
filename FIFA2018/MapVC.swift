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

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var mapView: NMAMapView!
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
        
        mapView.useHighResolutionMap = true
        mapView.positionIndicator.isVisible = true
        mapView.zoomLevel = 13.2
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: 55.716542, longitude: 37.553947), animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        
        if NMAPositioningManager.shared().startPositioning() {
            NotificationCenter.default.addObserver(self, selector: #selector(positionDidUpdate), name: .NMAPositioningManagerDidUpdatePosition, object: NMAPositioningManager.shared())
            
        }

        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getAllPoints")!, method: .post).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
//                    print(response.response)
//                    print(response.request)
//                    print(response.result.value)
                    let data = Mapper<GeoLocation>().mapArray(JSONObject: JSON["result"])
                    for geo in data! {
//                        let marker = NMAMapMarker.init(geoCoordinates: NMAGeoCoordinates.init(latitude: geo.Latitude, longitude: geo.Longitude))
//                        marker.title = "te"
//                        marker.icon = #imageLiteral(resourceName: "Pin")
//                        self.mapView.add(marker)
                        
                        let circle = NMAMapCircle.init(coordinates: NMAGeoCoordinates.init(latitude: geo.Latitude, longitude: geo.Longitude), radius: 20)
                        
                        circle.fillColor = .red
                        self.mapView.add(circle)
                        
                    }
                }
            case .failure(let error):
                print("Error \(error)")
                //fail(error as NSError)
            }
        }
    
        // Do any additional setup after loading the view.
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
    
    @IBAction func goToHomeAction(_ sender: Any) {
        //let params: Parameters = ["latitude"]
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/")!, method: .post).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
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

}
