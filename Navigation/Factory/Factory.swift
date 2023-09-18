import UIKit

final class Factory {
    
    enum Flow {
        case profile
        case feed
    }
    
    private let flow: Flow
    let navigationController = UINavigationController()
    
    init(flow: Flow) {
        self.flow = flow
        startModule()
        
    }
    
   private func startModule() {
        switch flow {
            
        case .profile:
            let service: UserService?
            
            #if DEBUG
            service = TestUserService()
            #else
            service = CurrentUserService()
            #endif
            
            guard let service = service else { return }
            let myLoginFactory = MyLoginFactory()
            let loginInspector = myLoginFactory.makeLoginInspector()
            
            let coordinator = ProfileCoordinator()
            coordinator.navigationController = navigationController
            let logInVC = LogInViewController(currentUserService: service, delegate: loginInspector, profileCoordinator: coordinator)
            logInVC.loginDelegate = loginInspector
            let image2 = UIImage.init(systemName: "person")
            let selectedImage2 = UIImage(systemName: "person.fill")
            navigationController.tabBarItem = UITabBarItem.init(title: "Profile", image: image2, selectedImage: selectedImage2)
            navigationController.setViewControllers([logInVC], animated: true)
            
        case .feed:
            let viewModel = FeedViewModel()
            let coordinator = FeedCoordinator()
            coordinator.nagigationController = navigationController
            let feedVC = FeedViewController(feedViewModel: viewModel, feedCoordinator: coordinator)
            let image = UIImage.init(systemName: "house")
            let selectedImage = UIImage.init(systemName: "house.fill")
            navigationController.tabBarItem = UITabBarItem.init(title: "Feed", image: image, selectedImage: selectedImage)
            navigationController.setViewControllers([feedVC], animated: true)
        }
    }
}
