import UIKit

class FeedModel {

    var secretWord = "пароль"
    
    func check(word: String) -> Bool {
        return word == secretWord
    }
}
