import UIKit

class PostVC: UIViewController {
    
    private let coordinator: FeedCoordinatorProtocol
    
    init(coordinator: FeedCoordinatorProtocol) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoBarButtonItem: UIBarButtonItem = {
        var button = UIBarButtonItem.init(title: NSLocalizedString("Info", comment: ""), style: .plain, target: self, action: #selector(showInfoScreen))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        title = NSLocalizedString("My Post", comment: "")
        
        setupViews()
        setupConstraints()
    }
    
    @objc func showInfoScreen() {
        coordinator.showInfo()
    }
    
    func setupViews() {
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    func setupConstraints() {
    }
}

