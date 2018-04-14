//
//  SelectSectorVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol SelectSectorVCDelegate {
    func didFinishWithSelectedSector (geo: GeoLocation)
}

class SelectSectorVC: UITableViewController {

    var data = [GeoLocation]()
    
    var delegate: SelectSectorVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request(URL(string:"https://fifa.bigbadbird.ru/api/getAllPoints")!, method: .post).responseJSON { (response) in
            switch response.result {
            case .success:
                if let JSON = response.result.value as? [String:AnyObject] {
                    self.data = Mapper<GeoLocation>().mapArray(JSONObject: JSON["result"])!
                    self.tableView.reloadData()
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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sector = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "\(sector.SectorName) - \(sector.SectorNumber)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sector = data[indexPath.row]
        delegate?.didFinishWithSelectedSector(geo: sector)
        navigationController?.popViewController(animated: true)
    }
}
