import UIKit

final class DangerButton: Button {
    override var isDisabled: Bool {
        didSet {
            isEnabled = !isDisabled
            applyStyle()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func applyStyle() {
        if !isDisabled {
            setTitleColor(.Theme.red, for: .normal)
            backgroundColor = .none
            layer.borderColor = UIColor.Theme.red.cgColor
            layer.borderWidth = 1
        } else {
            setTitleColor(.Theme.gray, for: .normal)
            layer.borderColor = UIColor.Theme.gray.cgColor
        }
    }
}
