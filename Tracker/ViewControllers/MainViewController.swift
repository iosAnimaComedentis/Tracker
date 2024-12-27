import UIKit

final class MainViewController: UIViewController {
    //MARK: Private Properties
    private let dateButton: UIButton = {
        let dateButton = UIButton()
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let dateString = dateFormatter.string(from: currentDate)
        
        dateButton.setTitle(dateString, for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "SF-Pro", size: 17)
        dateButton.backgroundColor = UIColor(hex: "#F0F0F0")
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.layer.cornerRadius = 8
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        return dateButton
    }()
    private let addTrackerButton: UIButton = {
        let addTrackerButton = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let image = UIImage(systemName: "plus")?.withConfiguration(config)
        addTrackerButton.tintColor = .ypBlack
        addTrackerButton.setImage(image, for: .normal)
        return addTrackerButton
    }()
    private let trackerTitle: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let searchBar: UISearchBar = {
        let serchBar = UISearchBar()
        serchBar.placeholder = "Поиск"
        serchBar.searchBarStyle = .minimal
        serchBar.translatesAutoresizingMaskIntoConstraints = false
        return serchBar
    }()
    private let nonTrackers: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        
        let stackImage = UIImageView(image: UIImage(resource: .stars))
        stackImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackImage.widthAnchor.constraint(equalToConstant: 80),
            stackImage.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        let title = UILabel()
        title.text = "Что будем отслеживать?"
        title.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        stack.addArrangedSubview(stackImage)
        stack.addArrangedSubview(title)
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: Private Methods
    
    /// add subView on MainView
    private func addSubView() {
        view.addSubview(trackerTitle)
        view.addSubview(searchBar)
        view.addSubview(nonTrackers)
    }
    
    /// setting constraint
    private func setupConstrait() {
        NSLayoutConstraint.activate([
            dateButton.widthAnchor.constraint(equalToConstant: 77),
            dateButton.heightAnchor.constraint(equalToConstant: 34),
            
            trackerTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            trackerTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1),
            
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.topAnchor.constraint(equalTo: trackerTitle.bottomAnchor, constant: 7),
            
            nonTrackers.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nonTrackers.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            nonTrackers.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 220)
            
        ])
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupMainView()
    }
    
    private func setupMainView(){
        view.backgroundColor = .ypWhite
        addSubView()
        setupConstrait()
    }
    
    /// фунция содержит элементы NavBar и таргеты кнопок
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: addTrackerButton)
        
        addTrackerButton.addTarget(
            self,
            action: #selector(addTrackerButtonTap),
            for: .touchUpInside
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dateButton)
        
        dateButton.addTarget(
            self,
            action: #selector(dateButtonTap),
            for: .touchUpInside
        )
    }
    
    @objc func addTrackerButtonTap() {
        let testViewController = TestButtonCon()
        navigationController?.pushViewController(
            testViewController,
            animated: false
        )
    }
    @objc func dateButtonTap() {
        let testViewController = TestButtonCon()
        navigationController?.pushViewController(
            testViewController,
            animated: false
        )
    }
}
