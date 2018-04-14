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

class MapVC: UIViewController {

    @IBOutlet weak var mapView: NMAMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.useHighResolutionMap = true
        mapView.zoomLevel = 13.2
        mapView.set(geoCenter: NMAGeoCoordinates(latitude: 55.716542, longitude: 37.553947), animation: .linear)
        mapView.copyrightLogoPosition = NMALayoutPosition.bottomCenter
        
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getAllPoints")!, method: .post).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
//                    print(response.response)
//                    print(response.request)
//                    print(response.result.value)
                    let data = Mapper<GeoLocation>().mapArray(JSONObject: JSON["result"])
                    for geo in data! {
                        let marker = NMAMapMarker.init(geoCoordinates: NMAGeoCoordinates.init(latitude: geo.Latitude, longitude: geo.Longitude))
                            marker.title = "te"
                            marker.icon = #imageLiteral(resourceName: "Pin")
                            self.mapView.add(marker)
                    }
                }
            case .failure(let error):
                print("Error \(error)")
                //fail(error as NSError)
            }
        }
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
