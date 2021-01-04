//
//  UIViewController+Ext.swift
//  GHFollowers
//
//  Created by Kalin Balabanov on 24/11/2020.
//

import UIKit // already imorts Foundation so we dont need the xtra redundant code
import SafariServices // adds the ability to add a safari VC

// fileprivate  var containerView: UIView! // although its a global variable it can only be accessed in this file due to fileprivate

extension UIViewController { // allowing the alertVC to be available within any viewController without writing the code repetetively and keeping it on the main thread
    
    // var containerView: UIView! cannot create variable in extensions
    
    func presentGFAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle  = .overFullScreen
            alertVC.modalTransitionStyle    = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
    func presentSafariVC(url: URL) { // common extension for presenting safari VC
        let safariVC                       = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
}
