import UIKit

func pluralizedForm(for number: Int, forms: (String, String, String)) -> String {
    let mod100 = number % 100
    let mod10 = number % 10

    if mod100 >= 11 && mod100 <= 19 {
        return forms.2
    }

    switch mod10 {
    case 1:
        return forms.0
    case 2...4:
        return forms.1
    default:
        return forms.2
    }
}

final class TrackersListCell: UICollectionViewCell {
    static let reuseIdentifier = "cell"
    
    private lazy var containerBody: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .systemGreen
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.backgroundColor = .white.withAlphaComponent(0.3)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .Theme.black
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "plus")
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .small)
        button.setPreferredSymbolConfiguration(imageConfiguration, forImageIn: .normal)
        button.setImage(image, for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        return button
    }()
    
    private func setColor(_ color: UIColor) {
        containerBody.backgroundColor = color
        addButton.backgroundColor = color
    }
    
    private func setEmoji(_ emoji: String) {
        emojiLabel.text = emoji
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func setSchedule(_ schedule: Int) {
        let singleDay = "день"
        let someDays = "дня"
        let pluralDays = "дней"
        let pluralizedSchedule = pluralizedForm(for: schedule, forms: (singleDay, someDays, pluralDays))
        scheduleLabel.text = "\(schedule) \(pluralizedSchedule)"
    }
    
    func setCompleted(_ completed: Bool) {
        let defaultImage = UIImage(systemName: "plus")
        let completedImage = UIImage(systemName: "checkmark")
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: completed ? .bold : .medium, scale: .small)
        addButton.setImage(completed ? completedImage : defaultImage, for: .normal)
        addButton.setPreferredSymbolConfiguration(imageConfiguration, forImageIn: .normal)
        addButton.layer.opacity = completed ? 0.3 : 1
    }
    
    func setInfo(_ info: Tracker) {
        setColor(info.color)
        setEmoji(info.emoji)
        setTitle(info.title)
        setSchedule(info.schedule.selectedDays.count)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        [
            containerBody,
            titleLabel,
            emojiLabel,
            scheduleLabel,
            addButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            containerBody.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerBody.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerBody.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerBody.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerBody.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.topAnchor.constraint(equalTo: containerBody.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: containerBody.leadingAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerBody.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: containerBody.bottomAnchor, constant: -12),
            
            scheduleLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            scheduleLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            scheduleLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            
            addButton.topAnchor.constraint(equalTo: containerBody.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),            
        ])
    }
}

