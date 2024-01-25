//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

class ___VARIABLE_sceneName___View: BaseActionableView<___VARIABLE_sceneName___ViewModelProtocol,
                                                       ___VARIABLE_sceneName___ViewModel> {
    override func configureBindings(with viewModel: ___VARIABLE_sceneName___ViewModel?) {
        guard let viewModel else { return }
        viewModel.bind(self) { [weak self] action in
            guard let self else { return }
            switch action {

            }
        }
    }

    override func setupUI() {

    }
}

// MARK: - private functions
private extension ___VARIABLE_sceneName___View {

}
