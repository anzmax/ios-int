import UIKit
import StorageService

class FeedVC: UIViewController {
    
    var post: Post? {
        didSet {
            self.title = post?.author
        }
    }
    
    private let feedCoordinator: FeedCoordinatorProtocol
    
    lazy var feedModel = FeedModel()
    private let feedViewModel: FeedViewModel
    
    init(feedViewModel: FeedViewModel, feedCoordinator: FeedCoordinatorProtocol) {
        self.feedViewModel = feedViewModel
        self.feedCoordinator = feedCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var checkGuessButton = CustomButton(title: "Check Guess", titleColor: .white) {
        self.buttonTapped()
        print("Button tapped")
    }
    
    lazy var passwordGuessTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Жду твое слово"
        textField.textColor = .black
        textField.tintColor = .gray
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .white
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var postButtonFirst: UIButton = {
        let button = UIButton(frame: CGRect.init(x: 0, y: 0, width: 250, height: 70))
        button.setTitle("Open Post", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(showPostScreen), for: .touchUpInside)
        button.backgroundColor = .systemTeal
        return button
    }()
    
    lazy var postButtonSecond: UIButton = {
        let button = UIButton(frame: CGRect.init(x: 0, y: 0, width: 250, height: 70))
        button.setTitle("Open Post", for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(showPostScreen), for: .touchUpInside)
        button.backgroundColor = .systemCyan
        return button
    }()
    
    lazy var colorIndicatorLabel: UILabel = {
        let label = UILabel()
        label.text = "Check Again"
        label.backgroundColor = .white
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        feedViewModel.initialState()
    }
    
    private func bindViewModel() {

        feedViewModel.stateChanged = { [weak self] state in
            
            guard let self else { return }
            
            switch state {
                
            case .initial:
                self.setupViews()
                self.setupConstraints()
                
            case .checkingGuess:
                self.checkGuess(word: self.passwordGuessTextField.text ?? "")

            case .error:
                print("error")
                
            case .alertSuccess:
                showAlert(message: "Угадал!")
                
            case .alertFailure:
                showAlert(message: "Пум пум пуууум:(")
                
            case .alertEmpty:
                showAlert(message: "Введите слово")
            case .navigateToPost:
                showPostScreen()
            }
        }
    }
    
    func setupViews() {
        view.backgroundColor = .systemOrange
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(postButtonFirst)
        verticalStackView.addArrangedSubview(postButtonSecond)
        view.addSubview(passwordGuessTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(colorIndicatorLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkAgainLabelTapped))
        colorIndicatorLabel.isUserInteractionEnabled = true
        colorIndicatorLabel.addGestureRecognizer(tapGesture)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            verticalStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
            
            passwordGuessTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            passwordGuessTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            passwordGuessTextField.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 20),
            passwordGuessTextField.heightAnchor.constraint(equalToConstant: 50),
            
            checkGuessButton.topAnchor.constraint(equalTo: passwordGuessTextField.bottomAnchor, constant: 20),
            checkGuessButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            checkGuessButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            
            
            colorIndicatorLabel.topAnchor.constraint(equalTo: checkGuessButton.bottomAnchor, constant: 20),
            colorIndicatorLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            colorIndicatorLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            colorIndicatorLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - Actions
    func showAlert(message: String) {
        let alertController = UIAlertController.init(title: "", message: message, preferredStyle: .alert)

        self.present(alertController, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func checkGuess(word: String) {
        let isCorrect = feedModel.check(word: word)
        
        if isCorrect {
            colorIndicatorLabel.backgroundColor = .systemGreen
            colorIndicatorLabel.textColor = .white
            colorIndicatorLabel.text = "Юхууу"
        } else {
            colorIndicatorLabel.backgroundColor = .systemRed
            colorIndicatorLabel.textColor = .white
            colorIndicatorLabel.text = "Мммм нет"
        }
    }
    
    func buttonTapped() {
        feedViewModel.sendAction(.checkGuessButtonTapped(word: passwordGuessTextField.text ?? ""))
    }

    @objc func checkAgainLabelTapped() {
        feedViewModel.sendAction(.checkAgainLabelTapped(word: passwordGuessTextField.text ?? ""))
        print("Label tapped")
    }
    
    @objc func showPostScreen() {
        feedCoordinator.showPost(coordinator: feedCoordinator)
    }
    
}