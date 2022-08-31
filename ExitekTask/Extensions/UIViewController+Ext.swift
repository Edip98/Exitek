//
//  UIViewController+Ext.swift
//  ExitekTask
//
//  Created by Эдип on 31.08.2022.
//

import UIKit

extension UIViewController {
    
    func presentAlertOnMainThread(title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}
