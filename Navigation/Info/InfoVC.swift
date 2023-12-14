import UIKit

class InfoVC: UIViewController {
    
    var residents: [Resident] = []
    
    let personService: PersonService
    let planetService: PlanetService
    let residentService: ResidentService
    init(personService: PersonService, planetService: PlanetService, residentService: ResidentService) {
        self.personService = personService
        self.planetService = planetService
        self.residentService = residentService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var alertButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Alert", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        return button
    }()
    
    var personInfoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Person", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var planetInfoLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Planet", comment: "")
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.register(ResidentCell.self, forCellReuseIdentifier: ResidentCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
        personInfoRequest()
        planetInfoRequest()
        //residentInfoRequest()
    }
    
    func setupViews() {
        view.backgroundColor = .systemGreen
        view.addSubview(alertButton)
        view.addSubview(personInfoLabel)
        view.addSubview(planetInfoLabel)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            alertButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            alertButton.widthAnchor.constraint(equalToConstant: 200),
            alertButton.heightAnchor.constraint(equalToConstant: 50),
            
            personInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            personInfoLabel.topAnchor.constraint(equalTo: alertButton.bottomAnchor, constant: 20),
            
            planetInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetInfoLabel.topAnchor.constraint(equalTo: personInfoLabel.bottomAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: planetInfoLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Actions
    @objc func showAlert() {
        
        let alertController = UIAlertController.init(title: NSLocalizedString("Title", comment: ""), message: NSLocalizedString("Message", comment: ""), preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    //MARK: - Requests
    func personInfoRequest() {
        personService.makePersonInfoRequest { [weak self] title in
            DispatchQueue.main.async {
                self?.personInfoLabel.text = title
            }
        }
    }
    
    func planetInfoRequest() {
        planetService.makePlanetInfoRequest { result in
            switch result {
            case .success(let planet):
                
                for residentUrl in planet.residents {
                    
                    self.residentInfoRequest(url: residentUrl)
                }
                
                DispatchQueue.main.async {
                    self.planetInfoLabel.text = "Orbital Period: \(planet.orbitalPeriod)"
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func residentInfoRequest(url: URL) {
        residentService.makeResidentRequest(url: url) { result in
            switch result {
            case .success(let resident):
                DispatchQueue.main.async {
                    self.residents.append(resident)
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension InfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResidentCell.id, for: indexPath) as! ResidentCell
        
        let resident = residents[indexPath.row]
        cell.residentLabel.text = resident.name
        
        return cell
    }
}

class ResidentCell: UITableViewCell {
    
    static let id = "ResidentCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    var residentLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Name", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(residentLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
            residentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            residentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            residentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
