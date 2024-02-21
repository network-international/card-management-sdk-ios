//
//  ViewPinViewModel.swift
//  NICardManagementSDK
//
//  Created by Gabriel Cernestean on 18.08.2023.
//

import Foundation
import UIKit

public protocol ViewPinService {
    func getPin() async throws -> String
}

class ViewPinViewModel {
    var startTimer = false
    
    private let displayAttributes: NIDisplayAttributes?
    private let service: ViewPinService
    
    private(set) var pin: String?
    
    init(displayAttributes: NIDisplayAttributes?, service: ViewPinService) {
        self.displayAttributes = displayAttributes
        self.service = service
    }
    
    func getPin() async throws {
        Task {
            do {
                let pin = try await service.getPin()
                self.pin = pin
                self.startTimer = true
            } catch {
                self.pin = "----"
                self.startTimer = false
                throw error
            }
        }
    }
}

// MARK: - Helpers/Utils
extension ViewPinViewModel {
    func font(for label: NILabels) -> UIFont? {
        displayAttributes?.font(for: label)
    }
    
    var theme: NITheme { /// default is light
        return displayAttributes?.theme ?? .light
    }
}
