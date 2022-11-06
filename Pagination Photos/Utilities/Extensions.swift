//
//  Extensions.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation
import UIKit
import LPSnackbar
extension UIViewController{
    func applyCirclePhoto(photo: UIImageView){
       // photo.layer.borderWidth = 1
        photo.layer.masksToBounds = false
        photo.layer.borderColor = UIColor.black.cgColor
        photo.layer.cornerRadius = photo.frame.height/2
        photo.clipsToBounds = true
    }
    func showSnackBar(){
       
        let snack = LPSnackbar(title: "network is not connected", buttonTitle: "dismiss")
        // Customize the snack
        snack.bottomSpacing = (tabBarController?.tabBar.frame.minX ?? 0)
        snack.view.titleLabel.font = UIFont.systemFont(ofSize: 20)

        // Show a snack to allow user to undo deletion
        snack.show(animated: true) { (undone) in
            if undone {
                snack.dismiss()
            } else {
                snack.show()
            }
        }
    }
    
}
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 8
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
