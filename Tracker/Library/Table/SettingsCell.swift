import UIKit

final class SettingsCell: UITableViewCell, SettingsCellProtocol {
    static let reuseIdentifier = "EventSettingsCell"
    
    func setTitle(_ title: String) {
        textLabel?.text = title
    }
    
    func setSubtitle(_ subtitle: String?) {
        detailTextLabel?.text = subtitle
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        backgroundColor = .Theme.backgroundGray
        selectionStyle = .none

        textLabel?.font = .systemFont(ofSize: 17)
        textLabel?.textColor = .Theme.black
        detailTextLabel?.font = .systemFont(ofSize: 17)
        detailTextLabel?.textColor = .Theme.gray
    }
}
