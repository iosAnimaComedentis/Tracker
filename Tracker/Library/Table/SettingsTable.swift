import UIKit

struct CellConfig {
    let accessoryType: UITableViewCell.AccessoryType
    let isSwitcher: Bool?

    init(accessoryType: UITableViewCell.AccessoryType = .none, accessoryView: UIView? = nil, isSwitcher: Bool? = nil) {
        self.accessoryType = accessoryType
        self.isSwitcher = isSwitcher
    }
}

protocol SettingsTableItem {
    var title: String { get }
    var subtitle: String? { get }
}

protocol SettingsTableSwitcherDelegate: AnyObject {
    func didChangeSwitcher(at: IndexPath, isOn: Bool)
}

final class SettingsTable: UITableView {
    private var reuseIdentifier: String = "SettingsCell"
    private var cell: SettingsCellProtocol?
    private var items: [SettingsTableItem] = []
    private(set) var selectedPaths: [IndexPath] = []
    private var cellConfig: CellConfig?

    weak var switcherDelegate: SettingsTableSwitcherDelegate?

    func configure(items: [SettingsTableItem], cell: SettingsCellProtocol.Type, reuseIdentifier: String? = nil) {
        self.items = items
        self.reuseIdentifier = reuseIdentifier ?? cell.reuseIdentifier
        register(cell, forCellReuseIdentifier: reuseIdentifier ?? cell.reuseIdentifier)
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)

        backgroundColor = .none
        dataSource = self
        rowHeight = 75
        separatorStyle = .singleLine
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        separatorColor = .Theme.gray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        setupConstraints()
    }

    func setSelectedPath(_ indexPath: IndexPath) {
        if selectedPaths.contains(indexPath) { return }
        selectedPaths = [indexPath]
    }

    func setSelectedPaths(_ paths: [IndexPath]) {
        selectedPaths = paths
    }

    func setCellConfig(_ config: CellConfig) {
        cellConfig = config
    }

    private func setupConstraints() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)

        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: -4),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 4),
        ])
    }
}

// MARK: - extensions

extension SettingsTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
        guard let eventSettingsCell = cell as? SettingsCellProtocol else {
            return UITableViewCell()
        }
        configCell(for: eventSettingsCell, with: indexPath)
        return eventSettingsCell
    }

    private func configCell(for cell: SettingsCellProtocol, with indexPath: IndexPath) {
        let cellInfo = items[indexPath.row]
        cell.setTitle(cellInfo.title)
        cell.setSubtitle(cellInfo.subtitle)
        cell.accessoryType = selectedPaths.contains(indexPath)
            ? .checkmark
            : (cellConfig?.accessoryType ?? .none)

        if cellConfig?.isSwitcher ?? false {
            let switcher = Switcher()
            switcher.didChangeValue = { [weak self] isOn in
                self?.switcherDelegate?.didChangeSwitcher(at: indexPath, isOn: isOn)
            }
            switcher.isOn = selectedPaths.contains(indexPath)
            cell.accessoryView = switcher
        }
    }
}
