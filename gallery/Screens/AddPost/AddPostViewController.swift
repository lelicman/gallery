//
//  AddPostViewController.swift
//  gallery
//
//  Created by Alexey Bondar on 1/24/24.
//  

import UIKit

class AddPostViewController: BaseViewController<AddPostViewModelProtocol, AddPostViewModel> {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .natural
        textField.textColor = R.color.colors.text.default()
        textField.font = .textRegular
        let placeholderColor = R.color.colors.text.default()?.withAlphaComponent(0.3) ?? .black.withAlphaComponent(0.3)
        textField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.title(),
                                                             attributes: [.foregroundColor: placeholderColor])
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .next
        textField.layer.borderColor = R.color.colors.text.default()?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 60))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.delegate = self
        return textField
    }()
    
    private lazy var descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .natural
        textField.textColor = R.color.colors.text.default()
        textField.font = .textRegular
        let placeholderColor = R.color.colors.text.default()?.withAlphaComponent(0.3) ?? .black.withAlphaComponent(0.3)
        textField.attributedPlaceholder = NSAttributedString(string: R.string.localizable.description(),
                                                             attributes: [.foregroundColor: placeholderColor])
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.layer.borderColor = R.color.colors.text.default()?.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        let spacerView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 60))
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = spacerView
        textField.delegate = self
        return textField
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .textRegular
        label.textColor = R.color.colors.text.default()?.withAlphaComponent(0.3)
        label.textAlignment = .left
        label.text = R.string.localizable.description()
        return label
    }()
    
    lazy private var sendButton: GradientBorderButton = {
        let button = GradientBorderButton(colors: [R.color.colors.controls.mauve(), R.color.colors.controls.malibu()].compactMap { $0 },
                                          startPoint: CGPoint(x: 0, y: 0.5),
                                          endPoint: CGPoint(x: 1.0, y: 0.5),
                                          cornerRadius: 10.0,
                                          borderWidth: 3.0)
        button.backgroundColor = R.color.colors.surface.background()
        button.titleLabel?.font = .textRegular
        button.setTitleColor(R.color.colors.text.default(), for: .normal)
        button.setTitle(R.string.localizable.createPost(), for: .normal)
        button.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        
        return button
    }()
    
    private let loaderView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.colors.surface.background()?.withAlphaComponent(0.7)
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = R.color.colors.text.default()
        return activityIndicator
    }()
    
    override func configureBindings(with viewModel: AddPostViewModel?) {
        guard let viewModel else { return }
        viewModel.bind(self) { [weak self] action in
            guard let self else { return }
            switch action {
            case .isLoading(let isLoading):
                self.loaderView.isHidden = !isLoading
                isLoading ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
            }
        }
    }

    override func setupUI() {
        view.clipsToBounds = true
        navigationItem.title = R.string.localizable.createPost()
        view.backgroundColor = R.color.colors.surface.background()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.leading.equalTo(32)
            make.trailing.equalTo(-32)
        }
        
        containerView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        containerView.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        containerView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(16)
            make.height.equalTo(80)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        loaderView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = hideKeyboardWhenTappedAround()
    }
}

// MARK: - UITextFieldDelegate
extension AddPostViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            descriptionTextField.becomeFirstResponder()
        } else {
            descriptionTextField.resignFirstResponder()
            viewModel?.createPost(with: titleTextField.text ?? "", description: descriptionTextField.text ?? "")
        }
        return true
    }

}

// MARK: - private functions
private extension AddPostViewController {
    @objc private func sendButtonClicked() {
        resignFirstResponder()
        viewModel?.createPost(with: titleTextField.text ?? "", description: descriptionTextField.text ?? "")
    }
}
