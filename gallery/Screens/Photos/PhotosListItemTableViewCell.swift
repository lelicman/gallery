//
//  PhotosListItemCollectionViewCell.swift
//  gallery
//
//  Created by Alexey Bondar on 1/21/24.
//  

import UIKit
import SDWebImage

class PhotosListItemTableViewCell: BaseActionableTableViewCell<PhotosListItemViewModelProtocol, PhotosListItemViewModel> {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .textRegular
        label.textColor = R.color.colors.text.default()
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           animations: { [weak self] in
                guard let self = self else { return }
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    
    override func configureBindings(with viewModel: PhotosListItemViewModel?) {
        guard let viewModel else { return }
        viewModel.bind(self) { [weak self] action in
            guard let self else { return }
            switch action {
            case .modelUpdated(let model):
                self.photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.photoImageView.sd_setImage(with: model.thumbnailUrl, placeholderImage: R.image.placeholder())
                self.titleLabel.text = model.title
            }
        }
    }

    override func setupUI() {
        addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalTo(photoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-4)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        titleLabel.text = ""
    }
}
