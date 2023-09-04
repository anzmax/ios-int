import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    var post: Post? {
        didSet {
            self.title = post?.author
        }
    }
    
    lazy var feedModel = FeedModel()
    
    lazy var checkGuessButton = CustomButton(title: "Check Guess", titleColor: .white)
    
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
        setupActions()
    }
    
    func setupViews() {
        view.backgroundColor = .systemOrange
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(postButtonFirst)
        verticalStackView.addArrangedSubview(postButtonSecond)
        view.addSubview(passwordGuessTextField)
        view.addSubview(checkGuessButton)
        view.addSubview(colorIndicatorLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(colorIndicatorLabelTapped))
        colorIndicatorLabel.isUserInteractionEnabled = true
        colorIndicatorLabel.addGestureRecognizer(tapGesture)
    }
    
    func setupActions() {
        checkGuessButton.onAction = {
            self.checkGuessButtonPressed()
        }
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
    @objc func showPostScreen() {
        let postVC = PostViewController.init()
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    @objc func colorIndicatorLabelTapped() {
        guard let word = passwordGuessTextField.text, !word.isEmpty else {
            let alertController = UIAlertController.init(title: "", message: "Слово, Сударь", preferredStyle: .alert)
            
            self.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        }
        
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

    func checkGuessButtonPressed() {
        guard let word = passwordGuessTextField.text, !word.isEmpty else {
            let alertController = UIAlertController.init(title: "", message: "Слово, Сударь", preferredStyle: .alert)

            self.present(alertController, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        }

        let isCorrect = feedModel.check(word: word)

        if isCorrect {
            let alertController = UIAlertController.init(title: "", message: "Угадал!", preferredStyle: .alert)

            self.present(alertController, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController.init(title: "", message: "Пум пум пуууум:(", preferredStyle: .alert)

            self.present(alertController, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
