//
//  Action.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 3/28/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import Foundation
import UIKit

extension AlertAction {
    enum Style {
        case `default`
        case cancel
        case destructive

        var alerActionStyle: UIAlertAction.Style {
            switch self {
            case .default: return .default
            case .cancel: return .cancel
            case .destructive: return .destructive
            }
        }
    }

    var alertAction: UIAlertAction {
        return UIAlertAction(title: title, style: style.alerActionStyle) {  _ in
            self.completion?()
        }
    }
}

class AlertAction {
    let title: String
    let completion: (() -> Void)?
    let style: Style

    init(title: String, completion: (() -> Void)?, style: AlertAction.Style) {
        self.title = title
        self.completion = completion
        self.style = style
    }
}

extension AlertAction {
    static var cancel: AlertAction {
        return AlertAction(title: R.string.localizable.cancel(), completion: nil, style: .cancel)
    }

    static var okay: AlertAction {
        return AlertAction(title: R.string.localizable.ok(), completion: nil, style: .default)
    }
}
