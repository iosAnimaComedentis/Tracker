import UIKit

struct CategoryCellConfig: SettingsTableItem {
    let title: String
    let subtitle: String?
}

final class CategoryViewController: UIViewController {
    private var categories: [CategoryCellConfig] = [
        .init(title: "Важное", subtitle: nil),
        .init(title: "Радостные мелочи", subtitle: nil),
        .init(title: "Самочувствие", subtitle: nil),
        .init(title: "Привычки", subtitle: nil),
    ]
    private var selectedCategory: CategoryCellConfig?

    private lazy var tableView = SettingsTable()
    private var tableHeightConstraint: NSLayoutConstraint!

    private lazy var emptyBlock: EmptyBlock = {
        let block = EmptyBlock()
        block.setLabel("Привычки и события можно\nобъединить по смыслу")
        return block
    }()

    private lazy var createCategoryButton: Button = {
        let button = Button()
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(didAddCategoryTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()

        tableView.configure(items: categories, cell: SettingsCell.self, reuseIdentifier: "categorySettingsCell")
        tableView.delegate = self
        setEmptyBlockVisible(categories.isEmpty)
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeightConstraint.constant = tableView.contentSize.height
    }

    @objc
    private func didAddCategoryTapped() {
        let viewController = NewCategoryViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }

    private func configureNavBar() {
        navigationItem.title = "Категория"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
    }

    private func setEmptyBlockVisible(_ isVisible: Bool) {
        emptyBlock.isHidden = !isVisible
    }

    private func setupConstraints() {
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint.isActive = true

        [
            emptyBlock,
            tableView,
            createCategoryButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -11),

            emptyBlock.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor),
        ])
    }
}

// MARK: - extensions

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = categories[indexPath.row]
        selectedCategory = config
        self.tableView.setSelectedPath(indexPath)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { _ in
            return UIMenu(children: [
                UIAction(title: "Редактировать") { [weak self] _ in
                    self?.edit(indexPath: indexPath)
                },
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    self?.delete(indexPath: indexPath)
                },
            ])
        })
    }

    private func edit(indexPath: IndexPath) {

    }

    private func delete(indexPath: IndexPath) {
    }
}
