//
//  UIApplication+Window.swift
//  7SpanPractical
//
//  Created by Hardik Modha on 29/11/24.
//

import Foundation
import UIKit

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}
