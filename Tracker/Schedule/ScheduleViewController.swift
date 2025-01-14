import UIKit

struct ScheduleCellConfig: SettingsTableItem {
    let title: String
    let subtitle: String?
}

final class ScheduleViewController: UIViewController {
    private var weekDays: [Weekday] = [
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday,
        .sunday,
    ]

    private var selectedPaths: Set<IndexPath> = []

    private lazy var tableView = SettingsTable()
    private var tableHeightConstraint: NSLayoutConstraint!

    private lazy var doneButton: Button = {
        let button = Button()
        button.setTitle("Готово", for: .normal)
        button.addTarget(self, action: #selector(didDoneTapped), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavBar()
        let tableItems = weekDays.map({ ScheduleCellConfig(title: $0.translated, subtitle: nil) })

        tableView.setCellConfig(.init(isSwitcher: true))
        tableView.configure(items: tableItems, cell: SettingsCell.self, reuseIdentifier: "scheduleSettingsCell")
        tableView.switcherDelegate = self

        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableHeightConstraint.constant = tableView.contentSize.height
    }

    @objc
    private func didDoneTapped() {
        dismiss(animated: true)
    }

    private func configureNavBar() {
        navigationItem.title = "Расписание"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
        ]
    }

    private func setupConstraints() {
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint.isActive = true
        [
            tableView,
            doneButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -11),

            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}

extension ScheduleViewController: SettingsTableSwitcherDelegate {
    func didChangeSwitcher(at indexPath: IndexPath, isOn: Bool) {
        if isOn {
            selectedPaths = selectedPaths.union([indexPath])
        } else {
            selectedPaths = selectedPaths.filter({ $0 != indexPath })
        }
    }
}
