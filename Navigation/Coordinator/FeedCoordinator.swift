import UIKit

protocol FeedCoordinatorProtocol {
    
    func showPost(coordinator: FeedCoordinatorProtocol)
    func showInfo()
}

final class FeedCoordinator: FeedCoordinatorProtocol {
    
    var nagigationController: UINavigationController?
    
    func showPost(coordinator: FeedCoordinatorProtocol) {
        let postVC = PostViewController(coordinator: coordinator)
        nagigationController?.pushViewController(postVC, animated: true)
    }
    
    func showInfo() {
        let infoVC = InfoViewController()
        nagigationController?.pushViewController(infoVC, animated: true)
    }
}
