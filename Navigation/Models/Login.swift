import UIKit

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) throws -> Bool
}

struct LoginInspector: LoginViewControllerDelegate {
    let checkerService: CheckerServiceProtocol

    init(checkerService: CheckerServiceProtocol) {
        self.checkerService = checkerService
    }

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

        return true
    }

    func check(login: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        if login.isEmpty {
            completion(false, AuthError.loginEmpty)
            return
        }

        if login.count < 5 {
            completion(false, AuthError.loginInvalid)
            return
        }

        if password.isEmpty {
            completion(false, AuthError.passwordEmpty)
            return
        }

        if password.count < 5 {
            completion(false, AuthError.passwordInvalid)
            return
        }

        checkerService.checkCredentials(email: login, password: password) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}


protocol LoginFactory {
    func makeLoginInspector() -> LoginInspector
}

struct MyLoginFactory: LoginFactory {
    let checkerService: CheckerServiceProtocol

    init(checkerService: CheckerServiceProtocol) {
        self.checkerService = checkerService
    }

    func makeLoginInspector() -> LoginInspector {
        return LoginInspector(checkerService: checkerService)
    }
}

