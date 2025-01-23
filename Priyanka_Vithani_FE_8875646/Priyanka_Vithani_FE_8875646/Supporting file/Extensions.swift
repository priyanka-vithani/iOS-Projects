//
//  Extensions.swift
//  Priyanka_Vithani_FE_8875646
//
//  Created by Priyanka Vithani on 09/12/23.
//

import Foundation
import MapKit

extension MKMapView {
    func getCurrentZoomLevel() -> Double {
        let zoomScale = bounds.size.width / visibleMapRect.size.width
        let zoomExponent = log2(zoomScale)
        let zoomLevel = 20 - zoomExponent
        
        return zoomLevel
    }
}
extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
