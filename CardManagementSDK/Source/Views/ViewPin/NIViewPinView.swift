//
//  NIViewPinView.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 17.08.2023.
//

import Foundation

import UIKit
// TODO: update fonts and displayAttributes usage
public final class NIViewPinView: UIView {
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var firstDigit: UILabel!
    @IBOutlet weak var secondDigit: UILabel!
    @IBOutlet weak var thirdDigit: UILabel!
    @IBOutlet weak var fourthDigit: UILabel!
    @IBOutlet weak var fifthDigit: UILabel!
    @IBOutlet weak var sixthDigit: UILabel!
    
    @IBOutlet weak var firstSeparator: UIView!
    @IBOutlet weak var secondSeparator: UIView!
    @IBOutlet weak var thirdSeparator: UIView!
    @IBOutlet weak var fourthSeparator: UIView!
    @IBOutlet weak var fifthSeparator: UIView!
    
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var countDownDecription: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var digits: [UILabel]?
    private var separators: [UIView]?

    private var timer: Timer?
    private var counter: Double = 0
    
    public var viewModel: ViewPinViewModel!
    
    // MARK: - Init
    /// Initialization of NIViewPinView
    /// To be used when creating the PIN view programatically
    /// - Parameters:
    ///   - language: language of UI, can be nil
    ///   - displayAttributes: input needed for the PIN visualization
    ///   - service: sdk instance
    ///   - timer: seconds needed for the PIN visualization
    ///
    ///   //viewModel?.callback = completion
    public init(viewModel: ViewPinViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        fromNib()
        hideUI(true)
        digits = [firstDigit, secondDigit, thirdDigit, fourthDigit, fifthDigit, sixthDigit]
        separators = [firstSeparator, secondSeparator, thirdSeparator, fourthSeparator, fifthSeparator]
        
        if self.borderView != nil {
            activityIndicator.startAnimating()
            updateUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fromNib()
    }
    
    // MARK: - Public
    /// Configure the NIViewPinView
    /// To be used ONLY if NIViewPinView is added in storyboard or xib
    /// - Parameters:
    ///   - service: sdk instance
    ///   - input: input needed for the PIN visualization
    ///   - timer: seconds needed for the PIN visualization
    public func configure(viewModel: ViewPinViewModel) {
        hideUI(true)
        activityIndicator.startAnimating()
        digits = [firstDigit, secondDigit, thirdDigit, fourthDigit, fifthDigit, sixthDigit]
        separators = [firstSeparator, secondSeparator, thirdSeparator, fourthSeparator, fifthSeparator]
        updateUI()
    }
    
    // MARK: - Private

    private func startTimer() {
        counter = viewModel.config.timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCounter() {
        if counter > 0 {
            countDownDecription.text = String(format: viewModel!.config.countDownTemplate, String(Int(counter)))
            counter -= 1
        } else {
            timer?.invalidate()
            maskPIN()
        }
    }
    
    private func maskPIN() {
        if let digits = digits {
            for digit in digits {
                digit.text = "＊"
            }
        }
        
        countDownDecription.isHidden = true
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }
        activityIndicator.style = .large
        stackView.semanticContentAttribute = .forceLeftToRight
        
        viewModel.bindCardDetailsViewModel = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.hideUI(false)
                
                if viewModel.pin?.count == 4 {
                    self.digits = [self.firstDigit, self.secondDigit, self.thirdDigit, self.fourthDigit]
                    self.fourthSeparator.isHidden = true
                    self.fifthDigit.isHidden = true
                    self.fifthSeparator.isHidden = true
                    self.sixthDigit.isHidden = true
                    self.updateFirst4Digits(viewModel: viewModel)
                } else if viewModel.pin?.count == 5 {
                    self.digits = [self.firstDigit, self.secondDigit, self.thirdDigit, self.fourthDigit, self.fifthDigit]
                    self.fourthSeparator.isHidden = false
                    self.fifthDigit.isHidden = false
                    self.fifthSeparator.isHidden = true
                    self.sixthDigit.isHidden = true
                    self.updateFirst4Digits(viewModel: viewModel)
                    self.fifthDigit.text = viewModel.pin?[4]
                } else if viewModel.pin?.count == 6 {
                    self.digits = [self.firstDigit, self.secondDigit, self.thirdDigit, self.fourthDigit, self.fifthDigit, self.sixthDigit]
                    self.fourthSeparator.isHidden = false
                    self.fifthDigit.isHidden = false
                    self.fifthSeparator.isHidden = false
                    self.sixthDigit.isHidden = false
                    self.updateFirst4Digits(viewModel: viewModel)
                    self.fifthDigit.text = viewModel.pin?[4]
                    self.sixthDigit.text = viewModel.pin?[5]
                }
                
                if viewModel.startTimer && self.counter != 0 {
                    self.startTimer()
                    self.countDownDecription.text = String(format: self.viewModel.config.countDownTemplate, String(Int(self.counter)))
                    self.counter -= 1
                } else {
                    self.countDownDecription.isHidden = true
                }
            }
        }
        
        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 15
                
        //TODO: use vm
        countDownDecription.font = UIElement.PinFormLabel.viewPinCountDownDescription.defaultFont
        if let digits = digits {
            for digit in digits {
                digit.font = UIElement.PinFormLabel.pinDigit.defaultFont
            }
        }
        
        if let color = viewModel.config.colorInput {
            borderColor(color: color)
            textColor(color: color)
        } else {
            // Theme
            backgroundColor = UIColor.clear
            borderColor(color: .label)
        }
    }
    
    private func hideUI(_ shouldHide: Bool) {
        borderView.isHidden = shouldHide
        countDownDecription.isHidden = shouldHide
        
        if let separators = separators {
            for separator in separators {
                separator.isHidden = shouldHide
            }
        }
        
        if let digits = digits {
            for digit in digits {
                digit.isHidden = shouldHide
            }
        }
    }
        
    private func updateFirst4Digits(viewModel: ViewPinViewModel) {
        firstDigit.text = viewModel.pin?[0]
        secondDigit.text = viewModel.pin?[1]
        thirdDigit.text = viewModel.pin?[2]
        fourthDigit.text = viewModel.pin?[3]
    }
    
    private func textColor(color: UIColor) {
        if let digits = digits {
            for digit in digits {
                digit.textColor = color
            }
        }
        
        countDownDecription.textColor = color
    }
    
    private func borderColor(color: UIColor) {
        firstSeparator.backgroundColor = color
        secondSeparator.backgroundColor = color
        thirdSeparator.backgroundColor = color
        fourthSeparator.backgroundColor = color
        fifthSeparator.backgroundColor = color
        borderView.layer.borderColor = color.cgColor
    }
}
