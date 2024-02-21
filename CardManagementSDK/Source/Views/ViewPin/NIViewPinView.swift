//
//  NIViewPinView.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 17.08.2023.
//

import Foundation

import UIKit

protocol NIViewPinViewDelegate: AnyObject {
    func viewPinView(_ view: NIViewPinView, didRetrieveWith error: NISDKError?)
}

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
    private var counter: Double = 0
    private var timer: Timer?
    private var colorInput: UIColor?
    
    var viewModel: ViewPinViewModel?
    
    weak var delegate: NIViewPinViewDelegate?
    
    // MARK: - Init
    /// Initialization of NIViewPinView
    /// To be used when creating the PIN view programatically
    /// - Parameters:
    ///   - displayAttributes: input needed for the PIN visualization
    ///   - service: sdk instance
    ///   - timer: seconds needed for the PIN visualization
    public init(displayAttributes: NIDisplayAttributes?, service: ViewPinService, timer: Double, color: UIColor? = nil) {
        counter = timer
        colorInput = color
        viewModel = ViewPinViewModel(displayAttributes: displayAttributes, service: service)
        super.init(frame: .zero)
        fromNib()
        hideUI(true)
        digits = [firstDigit, secondDigit, thirdDigit, fourthDigit, fifthDigit, sixthDigit]
        separators = [firstSeparator, secondSeparator, thirdSeparator, fourthSeparator, fifthSeparator]
        
        activityIndicator.style = .large
        UIFont.registerDefaultFonts()
        stackView.semanticContentAttribute = .forceLeftToRight
        
        if self.borderView != nil {
            activityIndicator.startAnimating()
            updateUI()
        }
        
        retrievePin()
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
    public func configure(displayAttributes: NIDisplayAttributes?, service: ViewPinService, timer: Double, color: UIColor? = nil, completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void) {
        hideUI(true)
        counter = timer
        colorInput = color
        viewModel = ViewPinViewModel(displayAttributes: displayAttributes, service: service)
        activityIndicator.startAnimating()
        digits = [firstDigit, secondDigit, thirdDigit, fourthDigit, fifthDigit, sixthDigit]
        separators = [firstSeparator, secondSeparator, thirdSeparator, fourthSeparator, fifthSeparator]
        updateUI()
        retrievePin()
    }
    
    // MARK: - Private
    
    private func retrievePin() {
        Task {
            var resultError: NISDKError?
            do {
                try await viewModel?.getPin()
            } catch {
                resultError = error as? NISDKError
            }
            DispatchQueue.main.async {
                self.handleVmChanged()
                self.delegate?.viewPinView(self, didRetrieveWith: resultError)
            }
        }
        
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCounter() {
        if counter > 0 {
            countDownDecription.text = "view_pin_countdown_description".localized + " " + String(Int(counter)) + " " + "view_pin_countdown_unit".localized
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
    
    private func handleVmChanged() {
        guard let viewModel = viewModel else { return }
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
            let countDownDescriptionLocalized: String = "view_pin_countdown_description".localized + " "
            let countDownUnitLocalized: String = " " + "view_pin_countdown_unit".localized
            self.countDownDecription.text = countDownDescriptionLocalized + String(Int(self.counter)) + countDownUnitLocalized
            self.counter -= 1
        } else {
            self.countDownDecription.isHidden = true
        }
    }
    
    private func updateUI() {
        guard let viewModel = viewModel else { return }

        borderView.layer.borderColor = UIColor.lightGray.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 15
                
        //set fonts
        countDownDecription.font = viewModel.font(for: .viewPinCountDownDescription)
        if let digits = digits {
            for digit in digits {
                digit.font = viewModel.font(for: .pinDigitLabel)
            }
        }
        
        if let color = colorInput {
            borderColor(color: color)
            textColor(color: color)
        } else {
            // Theme
            backgroundColor = UIColor.clear
            overrideUserInterfaceStyle = viewModel.theme == .light ? .light : .dark
            if viewModel.theme == .dark {
                borderColor(color: .white)
            }
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
    
    private func setupTheme(_ theme: NITheme) {
        switch theme {
        case .light:
            backgroundColor = UIColor.clear
            textColor(color: .darkerGrayLight!)
        case .dark:
            backgroundColor = UIColor.clear
            textColor(color: .white)
            borderColor(color: .white)
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
