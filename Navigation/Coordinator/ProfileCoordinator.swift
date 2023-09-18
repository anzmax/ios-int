import UIKit

protocol ProfileCoordinatorProtocol {
    func showProfile(coordinator: ProfileCoordinatorProtocol)
    func showPhotos()
}

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    
    func showProfile(coordinator: ProfileCoordinatorProtocol) {
        let profileVC = ProfileViewController(profileCoordinator: coordinator)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func showPhotos() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
}
