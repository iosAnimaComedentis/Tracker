import UIKit

protocol SettingsCellProtocol: UITableViewCell {
    static var reuseIdentifier: String { get }

    func setTitle(_ title: String)
    func setSubtitle(_ subtitle: String?)
}
