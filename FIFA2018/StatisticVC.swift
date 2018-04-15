//
//  StatisticVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import Alamofire
import ObjectMapper
import CoreLocation

class StatisticVC: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var stadiumText: UILabel!
    @IBOutlet weak var flagSecond: UIImageView!
    @IBOutlet weak var flagFirst: UIImageView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var countFirst: UILabel!
    @IBOutlet weak var countSecond: UILabel!
    let locationManager = CLLocationManager()

    var matches: Results<MatchModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matches = realm.objects(MatchModel.self)
        flagFirst.sd_setImage(with: URL(string:matches![0].Path))
        flagSecond.sd_setImage(with: URL(string:matches![1].Path))

        flagSecond.layer.cornerRadius = 50
        flagFirst.layer.cornerRadius = 50
        flagSecond.layer.masksToBounds = true
        flagFirst.layer.masksToBounds = true
        stadiumText.text = matches![0].Stadion?.Name
        loadData()
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        loadData()
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData () {
        let params:Parameters = ["latitude": locationManager.location?.coordinate.latitude ?? 0, "longitude": locationManager.location?.coordinate.longitude ?? 0]
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getMatchCountHandler")!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                print(response.result.value)
                if let JSON = response.result.value as? [String:AnyObject] {
                    let errorCode = JSON["errorCode"] as! Int
                    if errorCode == 0 {
                        let data = Mapper<MatchCountModel>().map(JSONObject: JSON["result"])
                        self.countFirst.text = "\(data?.Count1 ?? 0)"
                        self.countSecond.text = "\(data?.Count2 ?? 0)"
                    }
                }
            case .failure(let error):
                print("Error \(error)")
                //fail(error as NSError)
            }
            
        }
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
