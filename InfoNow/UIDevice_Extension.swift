//
//  UIDevice_Extension.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import Foundation
import UIKit

extension UIDevice {
    
    var isIpad: Bool {
        return userInterfaceIdiom == .pad
    }
}
