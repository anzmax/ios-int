import UIKit

protocol ProfileCoordinatorProtocol {
    func showProfile(coordinator: ProfileCoordinatorProtocol)
    func showPhotos()
}

final class ProfileCoordinator: ProfileCoordinatorProtocol {
    
    var navigationController: UINavigationController?
    
    func showProfile(coordinator: ProfileCoordinatorProtocol) {
        let profileVC = ProfileVC(profileCoordinator: coordinator)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func showPhotos() {
        let photosVC = PhotosVC()
        navigationController?.pushViewController(photosVC, animated: true)
    }
}
