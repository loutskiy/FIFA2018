//
//  ChatVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import RealmSwift

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let multipeerService = MultipeerManager()
    var messages: Results<MessageModel>?
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        multipeerService.delegate = self
        messages = realm.objects(MessageModel.self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        messageTextField.resignFirstResponder()
        if messageTextField.text != "" {
            multipeerService.send(message: messageTextField.text!)
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
        return cell
    }
    @IBAction func segmentChange(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            messages = realm.objects(MessageModel.self)
        case 1:
            messages = realm.objects(MessageModel.self).filter("countryId = 1")
        case 2:
            messages = realm.objects(MessageModel.self).filter("countryId = 2")

        default:
            messages = realm.objects(MessageModel.self)
        }
        tableView.reloadData()
    }
}

extension ChatVC : ServiceManagerDelegate {
    func messageReceived(manager: MultipeerManager, messageString: String) {
        OperationQueue.main.addOperation {
            let message = MessageModel()
//            let myvalue = realm.objects(MessageModel.self).last
//            let id = myvalue?.id ?? 0 + 1
//            message.id = id
            message.message = messageString
            message.time = Date()
            message.countryId = UserCache.countryId()
            //message.uuid = UserCache.uuid()
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
//
//    func colorChanged(manager: ColorServiceManager, colorString: String) {
//        OperationQueue.main.addOperation {
//            switch colorString {
//            case "red":
//                self.change(color: .red)
//            case "yellow":
//                self.change(color: .yellow)
//            default:
//                NSLog("%@", "Unknown color value received: \(colorString)")
//            }
//        }
//    }
    
}
