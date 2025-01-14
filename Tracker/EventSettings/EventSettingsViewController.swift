import UIKit

struct EventSettingsCellConfig: SettingsTableItem {
    let title: String
    let subtitle: String?
    let destination: UIViewController.Type
}

protocol EventSettingsViewControllerDelegate {
    func didComplete()
}

final class EventSettingsViewController: UIViewController {
    var delegate: EventSettingsViewControllerDelegate?

    private(set) var isIrregular: Bool = false

    private var cellConfigs: [EventSettingsCellConfig] = [
        .init(title: "Категория", subtitle: "Важное", destination: CategoryViewController.self),
        .init(title: "Расписание", subtitle: "Вт, Ср", destination: ScheduleViewController.self)
    ]

    private var tableHeightConstraint: NSLayoutConstraint!
    private var emojiCollectionHeightConstraint: NSLayoutConstraint!
    private var colorsCollectionHeightConstraint: NSLayoutConstraint!

    private lazy var contentView = UIView()
    private lazy var tableView = SettingsTable()
    private lazy var emojiCollection = EmojiCollection(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var colorsCollection: ColorsCollection = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collection = ColorsCollection(frame: .zero, collectionViewLayout: layout)
        return collection
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var nameInput: UIView = {
        let textField = TextField()
        textField.placeholder = "Введите название трекера"
        let errorWrapper = ValidationTextFieldWrapper(textField)
        errorWrapper.delegate = self
        return errorWrapper
    }()

    private lazy var cancelButton: Button = {
        let button = DangerButton()
        button.setTitle("Отменить", for: .normal)
        button.addTarget(self, action: #selector(didCancelTapped), for: .touchUpInside)
        return button
    }()

    private lazy var createButton: Button = {
        let button = Button()
        button.setTitle("Создать", for: .normal)
        button.addTarget(self, action: #selector(didCreateTapped), for: .touchUpInside)
        return button
    }()

    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavBar()
        view.backgroundColor = .white
        tableView.configure(items: cellConfigs, cell: SettingsCell.self, reuseIdentifier: "settingsCell")
        tableView.delegate = self
        tableView.setCellConfig(.init(accessoryType: .disclosureIndicator))
        createButton.isDisabled = true
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        emojiCollection.layoutIfNeeded()
        colorsCollection.layoutIfNeeded()
        emojiCollectionHeightConstraint.constant = emojiCollection.contentSize.height
        colorsCollectionHeightConstraint.constant = colorsCollection.contentSize.height
        tableHeightConstraint.constant = tableView.contentSize.height
    }

    func setIsIrregular(_ isIrregular: Bool) {
        self.isIrregular = isIrregular
        if isIrregular {
            cellConfigs = [
                .init(title: "Категория", subtitle: "Важное", destination: CategoryViewController.self),
            ]
        } else {
            cellConfigs = [
                .init(title: "Категория", subtitle: "Важное", destination: CategoryViewController.self),
                .init(title: "Расписание", subtitle: "Вт, Ср", destination: ScheduleViewController.self)
            ]
        }
        configureNavBar()
    }

    private func configureNavBar() {
        navigationItem.title = isIrregular ? "Новое нерегулярное событие" : "Новая привычка"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
    }

    private func setupConstraints() {
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        emojiCollectionHeightConstraint = emojiCollection.heightAnchor.constraint(equalToConstant: 0)
        colorsCollectionHeightConstraint = colorsCollection.heightAnchor.constraint(equalToConstant: 0)

        tableHeightConstraint.isActive = true
        emojiCollectionHeightConstraint.isActive = true
        colorsCollectionHeightConstraint.isActive = true

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        [
            nameInput,
            tableView,
            emojiCollection,
            colorsCollection,
            buttonsStack,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            nameInput.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            
            tableView.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: -19),

            emojiCollection.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -19),
            emojiCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            colorsCollection.topAnchor.constraint(equalTo: emojiCollection.bottomAnchor),
            colorsCollection.leadingAnchor.constraint(equalTo: emojiCollection.leadingAnchor),
            colorsCollection.trailingAnchor.constraint(equalTo: emojiCollection.trailingAnchor),
            
            buttonsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            buttonsStack.topAnchor.constraint(equalTo: colorsCollection.bottomAnchor, constant: 40),
            buttonsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    @objc
    private func didCancelTapped() {
        dismiss(animated: true)
    }

    @objc
    private func didCreateTapped() {
        dismiss(animated: true)
        delegate?.didComplete()
    }
}

// MARK: - extensions

extension EventSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let config = cellConfigs[indexPath.row]
        let viewController = config.destination.init()
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

extension EventSettingsViewController: ValidationTextFieldWrapperDelegate {
    func textFieldShouldReturn(_ textField: UITextField) {
        textField.resignFirstResponder()
    }

    func onError(_ hasError: Bool) {
        createButton.isDisabled = hasError
    }
}
