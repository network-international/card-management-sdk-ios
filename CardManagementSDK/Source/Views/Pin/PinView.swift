//
//  PinView.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 13.10.2022.
//

import UIKit

protocol PinViewProtocol: AnyObject {
    func pinFilled(pin: String)
}

class PinView: UIView {
    
    @IBOutlet private weak var dot1: DotView!
    @IBOutlet private weak var dot2: DotView!
    @IBOutlet private weak var dot3: DotView!
    @IBOutlet private weak var dot4: DotView!
    @IBOutlet private weak var dot5: DotView!
    @IBOutlet private weak var dot6: DotView!
    
    @IBOutlet private weak var button0: KeyboardButton!
    @IBOutlet private weak var button1: KeyboardButton!
    @IBOutlet private weak var button2: KeyboardButton!
    @IBOutlet private weak var button3: KeyboardButton!
    @IBOutlet private weak var button4: KeyboardButton!
    @IBOutlet private weak var button5: KeyboardButton!
    @IBOutlet private weak var button6: KeyboardButton!
    @IBOutlet private weak var button7: KeyboardButton!
    @IBOutlet private weak var button8: KeyboardButton!
    @IBOutlet private weak var button9: KeyboardButton!
    @IBOutlet private weak var deleteButton: KeyboardButton!
    @IBOutlet private weak var confirmButton: KeyboardButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let MIN_COUNT = 4
    private let MAX_COUNT = 6
    
    private var pin: String = ""
    private var dots: [DotView]?
    
    var viewmodel: PinViewViewModel? {
        didSet {
            updateUI()
        }
    }
    
    weak var pinDelegate: PinViewProtocol?
    
    // MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    // MARK: -
    func resetView() {
        pin = ""
        updateUI()
        enableButtons(true)
        setConfirmButton()
        dot1.shouldFillDot(false)
        dot2.shouldFillDot(false)
        dot3.shouldFillDot(false)
        dot4.shouldFillDot(false)
        dot5.shouldFillDot(false)
        dot6.shouldFillDot(false)
    }
    
    func disableButtons() {
        enableButtons(false)
        confirmButton.isEnabled = false
        deleteButton.isUserInteractionEnabled = false
    }

    func enableButtons() {
        enableButtons(true)
        confirmButton.isEnabled = true
        deleteButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Private methods
    private func updateUI() {
        guard let viewmodel = viewmodel else { return }
        
        if viewmodel.dotsCount == 4 {
            dots = [dot1, dot2, dot3, dot4]
            dot5.isHidden = true
            dot6.isHidden = true
        } else if viewmodel.dotsCount == 5 {
            dots = [dot1, dot2, dot3, dot4, dot5]
            dot5.isHidden = false
            dot6.isHidden = true
        } else if viewmodel.dotsCount == 6 {
            dots = [dot1, dot2, dot3, dot4, dot5, dot6]
            dot5.isHidden = false
            dot6.isHidden = false
        }
        
        descriptionLabel.text = viewmodel.descriptionText
        confirmButton.isEnabled = false
        deleteButton.isUserInteractionEnabled = true
        
        
        // Theme
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.backgroundColor
            overrideUserInterfaceStyle = viewmodel.theme == .light ? .light : .dark
        } else {
            /// Fallback on earlier versions
            setupTheme(viewmodel.theme)
        }
        
    }
    
    private func setupTheme(_ theme: NITheme) {
        switch theme {
        case .light:
            backgroundColor = UIColor.white
            descriptionLabel.textColor = .darkerGrayLight
            deleteButton.imageView?.tintColor = UIColor.darkerGrayLight
        case .dark:
            backgroundColor = UIColor.darkerGrayLight
            descriptionLabel.textColor = .white
            deleteButton.imageView?.tintColor = UIColor.darkerGrayDark
        }
        
        button0.setTheme(theme)
        button1.setTheme(theme)
        button2.setTheme(theme)
        button3.setTheme(theme)
        button4.setTheme(theme)
        button5.setTheme(theme)
        button6.setTheme(theme)
        button7.setTheme(theme)
        button8.setTheme(theme)
        button9.setTheme(theme)
    }
    
    
    private func addToPin(number: String) {
        guard let dotsArray = dots else {
            return
        }
        
        pin += number
        dotsArray[pin.count - 1].shouldFillDot(true)
        setConfirmButton()
        
        guard let vm = viewmodel else { return }
        let pinCount = vm.fixedLength ? vm.dotsCount : MAX_COUNT
        if pin.count == pinCount {
            enableButtons(false)
        }
    }
    
    private func setConfirmButton() {
        guard let vm = viewmodel else { return }
        let pinCount = vm.fixedLength ? vm.dotsCount : MIN_COUNT
        if pin.count >= pinCount {
            confirmButton.isEnabled = true
        } else {
            confirmButton.isEnabled = false
        }
    }
    
    private func enableButtons(_ enable: Bool) {
        button1.isUserInteractionEnabled = enable
        button2.isUserInteractionEnabled = enable
        button3.isUserInteractionEnabled = enable
        button4.isUserInteractionEnabled = enable
        button5.isUserInteractionEnabled = enable
        button6.isUserInteractionEnabled = enable
        button7.isUserInteractionEnabled = enable
        button8.isUserInteractionEnabled = enable
        button9.isUserInteractionEnabled = enable
        button0.isUserInteractionEnabled = enable
    }
    
    // MARK: - Buttons Actions
    
    @IBAction private func keyboardButtonsAction(_ sender: UIButton) {
        guard let number = sender.titleLabel?.text else {
            return
        }
        
        addToPin(number: number)
    }
    
    @IBAction private func deleteButtonAction(_ sender: Any) {
        guard pin != "" else {
            return
        }
        
        pin.removeLast()
        setConfirmButton()
        
        guard let vm = viewmodel else { return }
        
        if let dotsArray = dots {
            let pinCount = vm.fixedLength ? vm.dotsCount : MAX_COUNT
            if pin.count <= pinCount {
                enableButtons(true)
            }
            dotsArray[pin.count].shouldFillDot(false)
        }
    }
    
    @IBAction private func confirmButtonAction(_ sender: Any) {
        pinDelegate?.pinFilled(pin: pin)
    }
}
