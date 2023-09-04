import UIKit
import SnapKit

class ProfileHeaderView: UITableViewHeaderFooterView {
    
    static let id = "ProfileHeaderView"
    
    private lazy var statusButton = CustomButton(title: "Show Status", titleColor: .white)
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "No Drama Lama"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for something..."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "ava2")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 50
        image.clipsToBounds = true
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
//    private lazy var statusButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Show status", for: .normal)
//        button.backgroundColor = .systemBlue
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 10
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.shadowOffset = CGSize(width: 10, height: 10)
//        button.layer.shadowRadius = 4
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.7
//        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return button
//    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.placeholder = "Enter your text"
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.backgroundColor = UIColor.white
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: textField.frame.height))
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.addTarget(self, action: #selector(statusTextChanged), for: .editingChanged)
        return textField
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(nameLabel)
        self.addSubview(profileImageView)
        self.addSubview(statusLabel)
        self.addSubview(statusButton)
        self.addSubview(textField)
    }
    
    func setupActions() {
        statusButton.onAction = { [self] in
            if let text = self.textField.text, text.isEmpty {
                textField.layer.borderColor = UIColor.red.cgColor
                print("Enter your text")
            } else {
                print(statusLabel.text ?? "")
                statusLabel.text = statustext
                textField.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func setupConstraints() {
        let safeArea = self.safeAreaLayoutGuide

        nameLabel.snp.makeConstraints({ make in
            make.top.equalTo(safeArea).inset(27)
            make.left.equalTo(statusLabel)
        })
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeArea).inset(16)
            make.left.equalTo(safeArea).inset(16)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalTo(profileImageView.snp.right).offset(30)
        }
        
        statusButton.snp.makeConstraints { make in
            make.right.equalTo(safeArea).inset(16)
            make.left.equalTo(safeArea).inset(16)
            make.top.equalTo(profileImageView.snp.bottom).offset(34)
            make.height.equalTo(50)
        }
        
        textField.snp.makeConstraints { make in
            make.right.equalTo(safeArea).inset(16)
            make.left.equalTo(profileImageView.snp.right).offset(30)
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.height.equalTo(40)
        }
    }
    
    //MARK: - Action
    private var statustext: String = ""
    
    @objc func statusTextChanged(_ textField: UITextField) {
        statustext = textField.text ?? ""
    }
}

//MARK: - Extensions
extension ProfileHeaderView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            print("updated ->", updatedText)

            if updatedText.isNonEmpty {
                textField.layer.borderColor = UIColor.black.cgColor
            } else {
                textField.layer.borderColor = UIColor.red.cgColor
            }
        }
        return true
    }
}

extension String {
    var isNonEmpty: Bool {
        return !self.isEmpty
    }
}
