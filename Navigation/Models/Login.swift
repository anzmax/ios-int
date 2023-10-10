import UIKit

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) throws -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    
    func check(login: String, password: String) throws -> Bool {
        
        if login.isEmpty {
            throw AuthError.loginEmpty
        }
        
        if login.count < 5 {
            throw AuthError.loginInvalid
        }
        
        if password.isEmpty {
            throw AuthError.passwordEmpty
        }
        
        if password.count < 5 {
            throw AuthError.passwordInvalid
        }
        
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
