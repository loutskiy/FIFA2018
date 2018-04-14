//
//  AlertMessage.swift
//  Zachetka
//
//  Created by Mikhail Lutskiy on 16.02.2018.
//  Copyright © 2018 BigBadBird. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertMessage( text: String, title: String ) {
        let alertView = UIAlertController.init(title: title, message: text, preferredStyle: .alert)
        let alertCancel = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
        alertView.addAction(alertCancel)
        present(alertView, animated: true, completion: nil)
    }
}
