import UIKit
import FirebaseAuth

final class Checker: LoginViewControllerDelegate {
    
    let authService = Auth.auth()
    
    private let validLogin = "admin"
    private let validPassword = "1234567"
    
    static let shared = Checker.init()
    private init() {}
    
    internal func check(login: String, password: String) -> Bool {
        
        print(authService.currentUser?.email ?? "", login)
        
        return authService.currentUser?.email ?? "" == login
        
        //return authService.currentUser != nil
        
        //login == validLogin && password == validPassword
    }
}

