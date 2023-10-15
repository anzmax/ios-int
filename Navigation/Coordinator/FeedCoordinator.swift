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
        let personService = PersonService()
        let planetService = PlanetService()
        let residentService = ResidentService()
        let infoVC = InfoViewController(personService: personService, planetService: planetService, residentService: residentService)
        nagigationController?.pushViewController(infoVC, animated: true)
    }
}
