import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appConfiguration: AppConfiguration?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let urls = [
            "https://swapi.dev/api/people/8",
            "https://swapi.dev/api/starships/3",
            "https://swapi.dev/api/planets/5"
        ]
        
        if let randomURL = urls.randomElement(), let config = AppConfiguration(randomURL) {
            appConfiguration = config
            NetworkService.request(for: config)
        }
        
        let mainCoordinator = MainCoordinator()
        
        window = UIWindow.init(windowScene: windowScene)
        
        window?.rootViewController = mainCoordinator.startApplication()
        
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

