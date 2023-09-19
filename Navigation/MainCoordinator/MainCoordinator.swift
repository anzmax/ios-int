import UIKit

protocol MainCoordinatorProtocol {
    func startApplication() -> UIViewController
}

class MainCoordinator: MainCoordinatorProtocol {
    
    func startApplication() -> UIViewController {
        return TabBarController()
    }
}

