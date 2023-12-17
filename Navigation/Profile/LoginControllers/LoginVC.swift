import UIKit
import FirebaseAuth

enum AuthError: Error {
    case loginInvalid
    case passwordInvalid
    case loginEmpty
    case passwordEmpty
}

class LoginVC: UIViewController {
    
    let checkerService: CheckerServiceProtocol = CheckerService()
    
    var currentUserService: UserService
    var loginDelegate: LoginViewControllerDelegate?
    private let loginInspector: LoginInspector
    private let profileCoordinator: ProfileCoordinatorProtocol
    let passwordForce = BruteForce()
    
    init(currentUserService: UserService, delegate: LoginViewControllerDelegate, profileCoordinator: ProfileCoordinatorProtocol) {
        self.currentUserService = currentUserService
        self.loginDelegate = delegate
        self.loginInspector = LoginInspector(checkerService: checkerService)
        self.profileCoordinator = profileCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI
    lazy var loginButton = CustomButton(title: NSLocalizedString("Log in", comment: "")) { [self] in
            guard let loginDelegate = self.loginDelegate else { return }
            let login = self.loginTextField.text ?? ""
            let password = self.passwordTextField.text ?? ""
            
            checkerService.checkCredentials(email: login, password: password) { error in
                if let error = error {
                    self.showAuthError(error)
                } else {
                    self.profileCoordinator.showProfile(coordinator: self.profileCoordinator)
                }
            }
        }
    
    lazy var passwordGenerateButton = CustomButton(title: NSLocalizedString("Generate password", comment: "")) {
        
        self.activityIndicator.startAnimating()
        
        let randomPassword = self.generateRandomPassword(length: 3)
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let crackedPassword = self.passwordForce.bruteForce(passwordToUnlock: randomPassword)
        
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let password = crackedPassword {
                    self.passwordTextField.text = password
                    self.passwordTextField.isSecureTextEntry = false
                } else {
                    print(NSLocalizedString("Пароль не найден", comment: ""))
                }
            }
        }
    }
    
    lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("New User? Create account", comment: ""), for: .normal)
        button.setTitleColor(.customBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var logoImageView: UIView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.tintColor = .black
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .systemGray3
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.clipsToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.textColor = .customBlack
        textField.tintColor = .customGray
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        let placeholderText = NSLocalizedString("Email", comment: "")
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.customGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]

            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
#if DEBUG
        textField.text = "test@mail.ru"
#endif
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.text = ""
        textField.textColor = .customBlack
        textField.tintColor = .customGray
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        let placeholderText = NSLocalizedString("Password", comment: "")
            let attributes = [
                NSAttributedString.Key.foregroundColor: UIColor.customGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)
            ]

            textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)


        #if DEBUG
                textField.text = "123456"
        #endif
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .customWhite
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObservers()
    }
    
    func setupViews() {
        view.backgroundColor = .customWhite
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(loginTextField)
        verticalStackView.addArrangedSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(passwordGenerateButton)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(createAccountButton)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            verticalStackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            verticalStackView.heightAnchor.constraint(equalToConstant: 100),
            
            loginButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            createAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            createAccountButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            createAccountButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            passwordGenerateButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 100),
            passwordGenerateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordGenerateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordGenerateButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Actions
    func showAuthError(_ error: Error) {
        let alert = UIAlertController(title: NSLocalizedString("Ошибка входа", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    @objc func createAccountButtonTapped() {
        let vc = CreateAccountVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func generateRandomPassword(length: Int) -> String {
        let charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var password = ""
        
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(charset.count)))
            let randomChar = charset[charset.index(charset.startIndex, offsetBy: randomIndex)]
            password.append(randomChar)
        }
        
        return password
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    
    private func setupKeyboardObservers() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        notificationCenter.addObserver(
            self,
            selector: #selector(willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
}

//MARK: - Extensions
extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

