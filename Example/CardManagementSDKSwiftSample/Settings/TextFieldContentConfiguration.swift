//
//  TextFieldContentConfiguration.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 06.12.2023.
//

import UIKit

class TextFieldContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = nil
        var pickerSource: [String]? = nil
        var placeholder: String? = nil
        var textChanged: ((String?) -> Void)?

        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(configuration: self)
        }

        func updated(for state: UIConfigurationState) -> Configuration {
            return self
        }
    }
    
    var configuration: UIContentConfiguration {
        get {
            _configuration
        }
        set {
            if let config = newValue as? Configuration {
                apply(configuration: config)
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    fileprivate var _configuration = Configuration()

    private func apply(configuration: Configuration) {
        textField.text = configuration.text
        textField.placeholder = configuration.placeholder
        _configuration = configuration
        guard configuration.pickerSource != nil else {
            textField.inputView = nil
            return
        }
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        textField.inputView = pickerView
    }

    required init(configuration: Configuration) {
        textField = UITextField(frame: .zero)
        textField.clearButtonMode = .whileEditing
        //textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        textField.delegate = self

        addViews()
        apply(configuration: configuration)

        textFieldToken = NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: .main, using: { [weak self] notification in
            guard let textField = notification.object as? UITextField else {
                return
            }
            self?._configuration.textChanged?(textField.text)
        })
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addViews() {
        addSubview(textField)
        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: guide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }

    private let textField: UITextField
    private var textFieldToken: Any?
}

// MARK: - Picker
extension TextFieldContentView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { _configuration.pickerSource?.count ?? 0 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        _configuration.pickerSource?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = _configuration.pickerSource?[row]
        _configuration.textChanged?(textField.text)
        textField.resignFirstResponder()
    }
}

extension TextFieldContentView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension UICollectionViewListCell {
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
