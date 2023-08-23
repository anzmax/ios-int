import UIKit

final class Checker: LogInViewControllerDelegate {
    
    private let validLogin = "admin"
    private let validPassword = "1234567"
    
    static let shared = Checker.init()
    private init() {}
    
    internal func check(login: String, password: String) -> Bool {
        login == validLogin && password == validPassword 
    }
}

