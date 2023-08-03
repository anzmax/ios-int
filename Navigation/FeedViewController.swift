import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    var post: Post? {
        didSet {
            self.title = post?.author
        }
    }
    
    var verticalStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .white
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    lazy var postButtonFirst: UIButton = {
        let button = UIButton(frame: CGRect.init(x: 0, y: 0, width: 250, height: 70))
        button.setTitle("Open Post", for: .normal)
        button.addTarget(self, action: #selector(showPostScreen), for: .touchUpInside)
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    lazy var postButtonSecond: UIButton = {
        let button = UIButton(frame: CGRect.init(x: 0, y: 0, width: 250, height: 70))
        button.setTitle("Open Post", for: .normal)
        button.addTarget(self, action: #selector(showPostScreen), for: .touchUpInside)
        button.backgroundColor = .systemPink
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
        view.backgroundColor = .systemOrange
        view.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(postButtonFirst)
        verticalStackView.addArrangedSubview(postButtonSecond)
        
    }
    
    func setupConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            verticalStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            verticalStackView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        
    }
    
    @objc func showPostScreen() {
        let postVC = PostViewController.init()
        
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
}
