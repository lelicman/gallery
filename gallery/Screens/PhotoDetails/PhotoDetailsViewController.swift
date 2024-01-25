//
//  PhotoDetailsViewController.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit
import SDWebImage

class PhotoDetailsViewController: BaseViewController<PhotoDetailsViewModelProtocol, PhotoDetailsViewModel> {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .subheadlineSemibold
        label.textColor = R.color.colors.text.default()
        return label
    }()
    
    private let zoomView: ZoomImageView = {
        let zoomView = ZoomImageView()
        return zoomView
    }()
    
    private lazy var shareButton: UIBarButtonItem = {
        UIBarButtonItem(image: R.image.shareIcon(),
                        style: .plain,
                        target: self,
                        action: #selector(share))
    }()
    
    override func configureBindings(with viewModel: PhotoDetailsViewModel?) {
        guard let viewModel else { return }
        viewModel.bind(self) { [weak self] action in
            guard let self else { return }
            switch action {

            case .modelUpdated(let model):
                self.zoomView.imageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                self.zoomView.imageView.sd_setImage(with: model.url, placeholderImage: R.image.placeholder())
                self.titleLabel.text = model.title
            }
        }
    }

    override func setupUI() {
        navigationItem.title = R.string.localizable.details()
        view.backgroundColor = R.color.colors.surface.background()
        navigationItem.rightBarButtonItems = [shareButton]
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        view.addSubview(zoomView)
        zoomView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(zoomView.snp.width)
        }
    }
}

// MARK: - private functions
private extension PhotoDetailsViewController {
    @objc func share() {
        viewModel?.share(zoomView.imageView.image)
    }
}
