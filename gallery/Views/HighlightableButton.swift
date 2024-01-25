//
//  HighlightableButton.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import Foundation
import UIKit

class HighlightableButton: UIButton {
    var highlightingAnimation: ((Bool) -> Void)?
    var animationDuration: TimeInterval = 0.25
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: animationDuration,
                           delay: 0,
                           animations: { [weak self] in
                guard let self = self else { return }
                if let highlightedAnimation = self.highlightingAnimation {
                    highlightedAnimation(self.isHighlighted)
                }
                else {
                    self.alpha = self.isHighlighted ? 0.5 : 1
                }
            }, completion: nil)
        }
    }
}

