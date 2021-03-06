//
//  ChatVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import Alamofire
import CoreLocation
import SDWebImage

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let multipeerService = MultipeerManager()
    var messages: Results<MessageModel>?
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var sentButton: UIButton!
    var matches: Results<MatchModel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        multipeerService.delegate = self
        messages = realm.objects(MessageModel.self).sorted(byKeyPath: "time", ascending: false)
        matches = realm.objects(MatchModel.self)
        self.segmentControl.removeAllSegments()
        self.segmentControl.insertSegment(withTitle: "Все", at: 0, animated: true)
        self.segmentControl.insertSegment(withTitle: self.matches![0].Name, at: 1, animated: true)
        self.segmentControl.insertSegment(withTitle: self.matches![1].Name, at: 2, animated: true)
        self.segmentControl.selectedSegmentIndex = 0
        sentButton.layer.cornerRadius = 28.5
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            loadData()
        }
//        loadData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        loadData()
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    func loadData () {
        let params:Parameters = ["latitude": locationManager.location?.coordinate.latitude ?? 0, "longitude": locationManager.location?.coordinate.longitude ?? 0]
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getMatch")!, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                //print(params)
                if let JSON = response.result.value as? [String:AnyObject] {
                    let errorCode = JSON["errorCode"] as! Int
                    if errorCode == 0 {
                        autoreleasepool {
                            do {
                                let data = Mapper<MatchModel>().mapArray(JSONObject: JSON["result"])
                                for object in self.matches! {
                                    try! realm.write {
                                        realm.delete(object)
                                    }
                                }
                                try! realm.write {
                                    for object in data! {
                                        realm.add(object, update: true)
                                    }
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                        
                        //self.matches = Mapper<MatchModel>().mapArray(JSONObject: JSON["result"])!
                        self.segmentControl.removeAllSegments()
                        self.segmentControl.insertSegment(withTitle: "Все", at: 0, animated: true)
                        self.segmentControl.insertSegment(withTitle: self.matches![0].Name, at: 1, animated: true)
                        self.segmentControl.insertSegment(withTitle: self.matches![1].Name, at: 2, animated: true)
                        self.segmentControl.selectedSegmentIndex = 0
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        messageTextField.resignFirstResponder()
        if messageTextField.text != "" {
            multipeerService.sendNew(message: messageTextField.text!, countryId: UserCache.countryId())
            let message = MessageModel()
            message.message = "#\(messageTextField.text!)"
            message.time = Date()
            message.countryId = UserCache.countryId()
            //message.uuid = UserCache.uuid()
            let search = realm.objects(MessageModel.self).filter("message = '#\(messageTextField.text!)' AND countryId = \(UserCache.countryId())")
            print(search)
            for find in search {
                try! realm.write({
                    realm.delete(find)
                })
            }
            try! realm.write({
                realm.add(message)
            })
            messageTextField.text = ""
            self.tableView.reloadData()
        } else {
            showAlertMessage(text: "Введите текст", title: "Ошибка")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messages?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatCell
        cell.textChatLabel.text = messages![indexPath.row].message
        for match in matches! {
            if match.ID == messages![indexPath.row].countryId {
                cell.flagImage.sd_setImage(with: URL(string:match.Path))
            }
        }
        return cell
    }
    @IBAction func segmentChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            messages = realm.objects(MessageModel.self).sorted(byKeyPath: "time", ascending: false)
        case 1:
            messages = realm.objects(MessageModel.self).filter("countryId = \(self.matches![0].ID)").sorted(byKeyPath: "time", ascending: false)
        case 2:
            messages = realm.objects(MessageModel.self).filter("countryId = \(self.matches![1].ID)").sorted(byKeyPath: "time", ascending: false)

        default:
            messages = realm.objects(MessageModel.self)
        }
        tableView.reloadData()
    }
}

extension ChatVC : ServiceManagerDelegate {
    func messageReceived(manager: MultipeerManager, messageString: String, countryId: Int) {
        OperationQueue.main.addOperation {
            let message = MessageModel()
//            let myvalue = realm.objects(MessageModel.self).last
//            let id = myvalue?.id ?? 0 + 1
//            message.id = id
            message.message = "#\(messageString)"
            message.time = Date()
            message.countryId = countryId
            //message.uuid = UserCache.uuid()
            let search = realm.objects(MessageModel.self).filter("message = '#\(messageString)' AND countryId = \(countryId)")
            print(search)
            for find in search {
                try! realm.write({
                    realm.delete(find)
                })
            }
            try! realm.write({
                realm.add(message)
            })
            self.tableView.reloadData()
            print(messageString)
        }
    }
    
    
    func connectedDevicesChanged(manager: MultipeerManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            print("Connections: \(connectedDevices)")
        }
    }

    
}
