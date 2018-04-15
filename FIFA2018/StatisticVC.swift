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

class StatisticVC: UIViewController {

    @IBOutlet weak var flagSecond: UIImageView!
    @IBOutlet weak var flagFirst: UIImageView!
    @IBOutlet weak var textViewLabel: UILabel!
    
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
