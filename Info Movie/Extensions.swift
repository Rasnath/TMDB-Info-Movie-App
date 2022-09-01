//
//  Extensions.swift
//  Info Movie
//
//  Created by Fábio Silva  on 23/08/2022.
//

import Foundation
import UIKit

extension UIView {
    public var safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
}


