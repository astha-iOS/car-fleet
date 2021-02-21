//
//  extensions.swift
//  Car Fleet
//
//  Created by Astha yadav on 23/01/21.
//

import UIKit

var viewSpinner : UIView?

extension UIViewController{
        
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
            
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }
            
        viewSpinner = spinnerView
    }
        
    func removeSpinner() {
        DispatchQueue.main.async {
            viewSpinner?.removeFromSuperview()
            viewSpinner = nil
        }
    }
    
    func showToast(message : String) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - (self.view.frame.size.width-100)/2, y: self.view.frame.size.height/2-12, width: self.view.frame.size.width-100, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 17.0)
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0 
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 7.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
