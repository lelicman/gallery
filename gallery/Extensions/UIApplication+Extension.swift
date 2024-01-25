//
//  UIApplication+Extension.swift
//  gallery
//
//  Created by Alexey Bondar on 1/20/24.
//

import Foundation
import UIKit

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        let vc = connectedScenes.filter {
            $0.activationState == .foregroundActive
        }.first(where: { $0 is UIWindowScene })
            .flatMap( { $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)?
            .rootViewController?
            .topMostViewController()
        return vc
    }
}
