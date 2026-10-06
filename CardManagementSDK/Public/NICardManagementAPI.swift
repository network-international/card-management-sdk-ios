@_exported import NICardManagementSDKCore
import UIKit

extension NICardManagementAPI {
    // MARK: - Form factories (UI)

    public func displayCardDetailsForm(
        viewController: UIViewController,
        formTitle: String? = nil,
        cardAttributes: NICardAttributes,
        cardViewBackground: UIImage?,
        cardViewTextPositioning: NICardDetailsTextPositioning?,
        completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void
    ) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(errorMessage: "Form not allowed pushing on navigation controller")) {}
            return
        }
        let route = Route.cardDetails(
            title: formTitle ?? NISDKStrings.card_details_title.rawValue,
            cardAttributes,
            cardViewTextPositioning,
            cardViewBackground
        )
        makeCoordinator(with: viewController)
            .coordinate(route: route, completion: completion)
    }

    public func setPinForm(
        type: NIPinFormType,
        config: SetPinViewModel.Config = .default,
        viewController: UIViewController,
        completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void
    ) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(errorMessage: "Form not allowed pushing on navigation controller")) {}
            return
        }
        makeCoordinator(with: viewController)
            .coordinate(route: .setPin(type: type, config), completion: completion)
    }

    public func verifyPinForm(
        type: NIPinFormType,
        config: VerifyPinViewModel.Config = .default,
        viewController: UIViewController,
        completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void
    ) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(errorMessage: "Form not allowed pushing on navigation controller")) {}
            return
        }
        makeCoordinator(with: viewController)
            .coordinate(route: .verifyPin(type: type, config), completion: completion)
    }

    public func changePinForm(
        type: NIPinFormType,
        config: ChangePinViewModel.Config = .default,
        viewController: UIViewController,
        completion: @escaping (NISuccessResponse?, NIErrorResponse?, @escaping () -> Void) -> Void
    ) {
        if viewController is UINavigationController {
            completion(nil, NIErrorResponse(errorMessage: "Form not allowed pushing on navigation controller")) {}
            return
        }
        makeCoordinator(with: viewController)
            .coordinate(route: .changePin(type: type, config), completion: completion)
    }

    /// Fill a custom layout with SDK card elements. After building, call `presenter.showCardDetails(completion:)`.
    public func buildCardDetailsPresenter(cardAttributes: NICardAttributes) -> NICardElementsPresenter {
        let presenter = NICardElementsPresenter()
        presenter.setup(cardAttributes: cardAttributes, service: self)
        return presenter
    }

    fileprivate func makeCoordinator(with navigationController: UIViewController) -> FormCoordinator {
        FormCoordinator(
            navigationController: navigationController,
            service: self
        )
    }
}

extension NICardManagementAPI: FormCoordinatorService {}
extension NICardManagementAPI: ViewPinService {}
