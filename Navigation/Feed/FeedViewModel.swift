import UIKit

final class FeedViewModel {
    
    lazy var feedModel = FeedModel()
    
    enum Action {
        case checkAgainLabelTapped(word: String)
        case checkGuessButtonTapped(word: String)
        case postButtonTapped
    }
    
    enum State {
        case initial
        case navigateToPost
        case checkingGuess(word: String)
        case alertSuccess
        case alertFailure
        case alertEmpty
        case error
    }
    
    var stateChanged: ((State) -> Void)?
    
    private(set) var state: State = .initial {
        didSet {
            stateChanged?(state)
        }
    }
    
    func initialState() {
        state = .initial
    }
    
    func sendAction(_ action: Action) {
        
        switch action {
            
        case .checkAgainLabelTapped(word: let word):
            
            if word.isEmpty {
                state = .alertEmpty
                return
            }
            state = .checkingGuess(word: word)
            
        case .checkGuessButtonTapped(word: let word):
            
            let isCorrect = feedModel.check(word: word)
            
            if word.isEmpty {
                state = .alertEmpty
                return
            }
            
            if isCorrect {
                state = .alertSuccess
            } else {
                state = .alertFailure
            }
        case .postButtonTapped:
            state = .navigateToPost
        }
    }
}


