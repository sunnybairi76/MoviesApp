//
//  ObservableProtocol.swift
//  Assigntment
//
//  Created by Bairi Akash on 29/08/23.
//

import Foundation
import UIKit

//observer pattern
protocol ObserverProtocol{
    func onValueChanged()
}
protocol ObservableProtocol{
    func addObserver(observer : ObserverProtocol)
    func removeObserver()
    func notifyObservers()
}

//load handlers
protocol LoadHandler {
    func addLoader(onto superview: UIView)
    func removeLoader()
}
//page handlers
protocol PageControlHandler {
    func gotoNextPage()
    func gotoPrevPage()
}
