//
//  Loader.swift
//  Assigntment
//
//  Created by Bairi Akash on 11/09/23.
//

import Foundation
import UIKit

class Loader: LoadHandler {
    
    var backgroundView: UIView
    var animation: UIActivityIndicatorView
    
    init(superview: UIView){
        backgroundView = UIView(frame: superview.frame)
        backgroundView.backgroundColor = UIColor(white: 0.25, alpha: 0.75)
        
        let X = CGFloat((superview.frame.width) / 2 ) - 50
        let Y = CGFloat((superview.frame.height) / 2 ) - 50
        
        let rectangularFrame = CGRect(x: X,y: Y,width: 100,height: 100)
        
        animation = UIActivityIndicatorView(frame: rectangularFrame)
        animation.startAnimating()
    }
    
    func addLoader(onto superview: UIView) {
        superview.addSubview(self.backgroundView)
        superview.addSubview(self.animation)
    }
    
    func removeLoader() {
        self.animation.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
}
