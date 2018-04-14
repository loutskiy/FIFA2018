//
//  PickerVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import SDWebImage
import CoreLocation
import ObjectMapper

class PickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    @IBOutlet weak var collectionView: UICollectionView!
    
    var matches = [MatchModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 15
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            loadData()
        }
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        loadData()
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func loadData() {
        let params:Parameters = ["latitude": locationManager.location?.coordinate.latitude ?? 0, "longitude": locationManager.location?.coordinate.longitude ?? 0]
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getMatch")!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                //print(params)
                if let JSON = response.result.value as? [String:AnyObject] {
                    let errorCode = JSON["errorCode"] as! Int
                    if errorCode == 0 {
                        self.matches = Mapper<MatchModel>().mapArray(JSONObject: JSON["result"])!
                        self.collectionView.reloadData()
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
    
    override func viewDidAppear(_ animated: Bool) {
//        UserCache.changeLoginState(true)
//        UserCache.setDate(Date())
//        UserCache.setCountryId(3)
//        let uuid = UUID.init().uuidString
//        UserCache.setUUID(uuid)
//        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let match = matches[indexPath.row]
        UserCache.changeLoginState(true)
        UserCache.setDate(Date())
        UserCache.setCountryId(match.ID)
        let uuid = UUID().uuidString
        UserCache.setUUID(uuid)
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let match = matches[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CountryCell
        cell.countryName.text = match.Name
        cell.imgaeView.sd_setImage(with: URL(string:match.Path))
        cell.imgaeView.layer.cornerRadius = 49.5
        cell.imgaeView.layer.masksToBounds = true
        return cell
    }
    

}
