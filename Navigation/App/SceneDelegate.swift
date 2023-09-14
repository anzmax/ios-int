import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let feedVC = FeedViewController(feedViewModel: FeedViewModel())
        
        var service: UserService?
        
        #if DEBUG
        service = TestUserService()
        #else
        service = CurrentUserService()
        #endif
        
        guard let service = service else { return }
        
        let myLoginFactory = MyLoginFactory()
        let loginInspector = myLoginFactory.makeLoginInspector()
        
        let logInVC = LogInViewController(currentUserService: service, delegate: loginInspector)
        logInVC.loginDelegate = loginInspector
        
        let tabBarController = UITabBarController.init()
        
        let feedNav = UINavigationController(rootViewController: feedVC)
        
        
        let image = UIImage.init(systemName: "house")
        let selectedImage = UIImage.init(systemName: "house.fill")
        
        feedNav.tabBarItem = UITabBarItem.init(title: "Feed", image: image, selectedImage: selectedImage)
        
        let profileNav = UINavigationController(rootViewController: logInVC)
        
        let image2 = UIImage.init(systemName: "person")
        let selectedImage2 = UIImage(systemName: "person.fill")
        profileNav.tabBarItem = UITabBarItem.init(title: "Profile", image: image2, selectedImage: selectedImage2)
        
        tabBarController.viewControllers = [feedNav, profileNav]
        
        window = UIWindow.init(windowScene: windowScene)
        
        window?.rootViewController = tabBarController
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

