//
//  BasePageViewController.swift
//  PDFScanner_free
//
//  Created by Andrei Evstratenko on 3/24/22.
//  Copyright © 2022 Apalon Apps. All rights reserved.
//

import UIKit

class BasePageViewController<P, ViewModel: BaseActionViewModelProtocol>: UIPageViewController {
    var viewModel: P? {
        didSet {
            (oldValue as? ViewModel)?.unbind(self)
            configureBindings(with: viewModel as? ViewModel)
        }
    }
    
    init(with viewModel: ViewModel? = nil,
         transitionStyle: UIPageViewController.TransitionStyle = .scroll,
         navigationOrientation: UIPageViewController.NavigationOrientation) {
        self.viewModel = viewModel as? P
        super.init(transitionStyle: transitionStyle,
                   navigationOrientation: navigationOrientation)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        (viewModel as? ViewModel)?.unbind(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureBindings(with: viewModel as? ViewModel)
    }
    
    func configureBindings(with viewModel: ViewModel?) {}
    func setupUI() {}
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }
}

extension BasePageViewController {
    
    var isPageControlHidden: Bool {
        get {
            (view.subviews.first(where: { $0 is UIPageControl }) as? UIPageControl)?.isHidden ?? true
        }
        set {
            (view.subviews.first(where: { $0 is UIPageControl }) as? UIPageControl)?.isHidden = newValue
        }
    }
    
    var pageControlTouchesEnabled: Bool {
        get {
            (view.subviews.first(where: { $0 is UIPageControl }) as? UIPageControl)?.isUserInteractionEnabled ?? false
        }
        set {
            (view.subviews.first(where: { $0 is UIPageControl }) as? UIPageControl)?.isUserInteractionEnabled = newValue
        }
    }
    
    var isScrollEnabled: Bool {
        get {
            (view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView)?.isScrollEnabled ?? false
        }
        set {
            (view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView)?.isScrollEnabled = newValue
        }
    }
    
    func goToViewController(viewController: UIViewController,
                            direction: UIPageViewController.NavigationDirection = .forward,
                            animated: Bool = true,
                            completion: ((Bool) -> Void)? = nil) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: animated,
                           completion: completion)
    }
}
