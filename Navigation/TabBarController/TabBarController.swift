import UIKit

final class TabBarController: UITabBarController {
    
    private let logInVC = Factory(flow: .profile)
    private let feedVC = Factory(flow: .feed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setControllers()
        view.backgroundColor = .white
    }
    
    private func setControllers() {
        viewControllers = [
            logInVC.navigationController,
            feedVC.navigationController
        ]
    }
}

