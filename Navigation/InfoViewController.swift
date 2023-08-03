import UIKit

class InfoViewController: UIViewController {
    
    lazy var alertButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 250, height: 70))
        button.setTitle("Alert", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.backgroundColor = .systemRed
        return button
    }()
    
    @objc func showAlert() {
        print("Show Alert")
        
        let alertController = UIAlertController.init(title: "Title", message: "Message", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubview(alertButton)
    }
    
    func setupConstraints() {
        alertButton.center = view.center
    }
}

