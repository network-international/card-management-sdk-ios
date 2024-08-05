//
//  StepperContentConfigaration.swift
//  CardManagementSDKSwiftSample
//
//  Created by Aleksei Kiselev on 13.12.2023.
//

import UIKit

class StepperContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var name: String = ""
        
        var initialValue: Double = 0
        var min: Double = -99999
        var max: Double = 99999
        var stepValue: Double = 0.1
        var updatedValue: ((Double) -> Void)?

        func makeContentView() -> UIView & UIContentView {
            return StepperContentView(configuration: self)
        }

        func updated(for state: UIConfigurationState) -> Configuration {
            return self
        }
    }
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }

    private let stepper: UIStepper
    private let valueLabel: UILabel
    private let nameLabel: UILabel

    required init(configuration: Configuration) {
        self.configuration = configuration
        stepper = UIStepper(frame: .zero)
        valueLabel = UILabel(frame: .zero)
        nameLabel = UILabel(frame: .zero)
        super.init(frame: .zero)
        addViews()
        configure(configuration: configuration)
        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        nameLabel.text = configuration.name
        valueLabel.text = String(format: "%.2f", configuration.initialValue)
        stepper.value = configuration.initialValue
        stepper.maximumValue = configuration.max
        stepper.minimumValue = configuration.min
        stepper.stepValue = configuration.stepValue
        stepper.wraps = true
    }
    
    @objc private func stepperValueChanged(_ sender: UIStepper) {
        let value = sender.value
        valueLabel.text = String(format: "%.2f", value)
        (configuration as? Configuration)?.updatedValue?(value)
    }
    
    private func addViews() {
        addSubview(stepper)
        addSubview(valueLabel)
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        stepper.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let guide = layoutMarginsGuide
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 2),
            stepper.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 2),
            stepper.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            
            stepper.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: guide.centerYAnchor),
        ])
    }
}

extension UICollectionViewListCell {
    func stepperConfiguration() -> StepperContentView.Configuration {
        StepperContentView.Configuration()
    }
}
