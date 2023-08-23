import UIKit

class LogInViewController: UIViewController {
    
    var currentUserService: UserService
    var loginDelegate: LogInViewControllerDelegate?
    
    init(currentUserService: UserService, delegate: LogInViewControllerDelegate) {
        self.currentUserService = currentUserService
        self.loginDelegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var logoImageView: UIView = {
        let logo = UIImageView()
        logo.image = UIImage(named: "logo")
        logo.translatesAutoresizingMaskIntoConstraints = false
        return logo
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
    
    private lazy var logInTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Email or phone"
        textField.textColor = .black
        textField.tintColor = .gray
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        
        #if DEBUG
        textField.text = "admin"
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
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.tintColor = .gray
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        
        #if DEBUG
        textField.text = "1234567"
        #endif
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private lazy var logInButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        button.setBackgroundImage(UIImage(named: "blue_pixel2"), for: .selected)
        button.setBackgroundImage(UIImage(named: "blue_pixel2"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "blue_pixel2"), for: .disabled)
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        return button
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
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
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
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        
        scrollView.contentInset.bottom += keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        
        scrollView.contentInset.bottom = 0.0
    }
    
    func setupViews() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(logInTextField)
        verticalStackView.addArrangedSubview(passwordTextField)
        contentView.addSubview(logInButton)
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
            
            logInButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 16),
            logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc func logInButtonPressed() {
        guard let loginDelegate = loginDelegate else {return}
        let login = logInTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if loginDelegate.check(login: login, password: password) {
            let profileVC = ProfileViewController()
            navigationController?.pushViewController(profileVC, animated: true)
        } else if login.isEmpty || password.isEmpty {
            let alertController = UIAlertController.init(title: "", message: "Введите логин и пароль", preferredStyle: .alert)
            
            self.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        } else {
            let alertController = UIAlertController.init(title: "Ошибка", message: "Неверный логин или пароль", preferredStyle: .alert)
            
            self.present(alertController, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                alertController.dismiss(animated: true, completion: nil)
            }
            return
        }
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
extension LogInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
}

