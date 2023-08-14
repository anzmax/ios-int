import UIKit

protocol LogInViewControllerDelegate {
    
    func check(login: String, password: String) -> Bool
}

struct LoginInspector: LogInViewControllerDelegate {
    
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}

protocol LoginFactory {
    
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    
    func makeLoginInspector() -> LoginInspector {
        return LoginInspector()
    }
    
    
}
