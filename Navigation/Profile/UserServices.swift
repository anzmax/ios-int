import UIKit

protocol UserService {
    func getUser(_ login: String) -> User?
}

class CurrentUserService: UserService {
    
    var user: User = User(login: "admin", fullName: "Admin Adminovich", avatar: UIImage(named: "ava") ?? UIImage(), status: "Hello")

    func getUser(_ login: String) -> User? {
        return user
    }
}

class TestUserService: UserService {
    
    var user: User = User(login: "test", fullName: "Test Testovich", avatar: UIImage(named: "ava3") ?? UIImage(), status: "WooHoo")
    
    func getUser(_ login: String) -> User? {
        return user
    }
}
