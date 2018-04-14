//
//  LoadVC.swift
//  FIFA2018
//
//  Created by Mikhail Lutskiy on 14.04.2018.
//  Copyright © 2018 Mikhail Lutskii. All rights reserved.
//

import UIKit

class LoadVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let date = Date().addingTimeInterval(60*60*24)
        if UserCache.isLogin() && UserCache.date() < date {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBar")
            present(vc!, animated: true, completion: nil)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PickerVC") as! PickerVC
            let nav = UINavigationController.init(rootViewController: vc)
            nav.navigationBar.backgroundColor = .red
            nav.navigationBar.barStyle = .blackTranslucent
            vc.title = "Добро пожаловать"
            present(nav, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
