import UIKit

final class Checker: LogInViewControllerDelegate {
    
    static let shared = Checker()
    private let validLogin = "admin"
    private let validPassword = "1234567"
    private init() {}
    
    internal func check(login: String, password: String) -> Bool {
        if login == validLogin && password == validPassword {
            return true
        }
        return false
    }
}

