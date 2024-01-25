//
//  GradientBorderButton.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//

import UIKit
import SnapKit

class GradientBorderButton: HighlightableButton {
    private var colors: [UIColor] = [.white, .black]
    private var startPoint = CGPoint(x: 0, y: 0.5)
    private var endPoint = CGPoint(x: 1.0, y: 0.5)
    private var cornerRadius: CGFloat = 0
    private var borderWidth: CGFloat = 0
    private var gradientLayer = CAGradientLayer()
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = backgroundColor
        backgroundView.clipsToBounds = true
        backgroundView.isUserInteractionEnabled = false
        return backgroundView
    }()
    
    override var backgroundColor: UIColor? {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }
    
    convenience init() {
        self.init(frame: .zero)
        setupUI()
    }
    
    convenience init(colors: [UIColor] = [],
                     startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                     endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5),
                     cornerRadius: CGFloat = 0,
                     borderWidth: CGFloat = 0) {
        self.init(frame: .zero)
        self.colors = colors
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        backgroundColor = .white
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    internal func setupUI() {
        setupGradient()
        setupBackgroundView()
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
}

// MARK: - private functions
private extension GradientBorderButton {
    func setupGradient() {
        gradientLayer.removeFromSuperlayer()
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map({ return $0.cgColor })
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setupBackgroundView() {
        backgroundView.removeFromSuperview()
        insertSubview(backgroundView, at: 1)
        backgroundView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(borderWidth)
            make.trailing.bottom.equalToSuperview().offset(-borderWidth)
        }
        backgroundView.layer.cornerRadius = cornerRadius - borderWidth
    }
}
