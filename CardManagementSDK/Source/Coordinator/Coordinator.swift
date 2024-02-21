//
//  Coordinator.swift
//  NICardManagementSDK
//
//  Created by Paula Radu on 05.10.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UIViewController { get set }
    func coordinate(route: Route, completion: @escaping (NIErrorResponse?) -> Void)
}


extension Coordinator {
    
    func present(_ viewController: UIViewController, animated: Bool = true, completion: (()->())? = nil) {
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .fullScreen
        navigationController.present(navController, animated: animated, completion: completion)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        if let navController = navigationController.navigationController {
            navController.pushViewController(viewController, animated: animated)
        }
    }
    
    func dismissPresentedViewController(_ animated: Bool = true, completion: (()->())? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func pop(_ animated: Bool = true) {
        if let navController = navigationController as? UINavigationController {
            navController.popViewController(animated: animated)
        }
    }
}
