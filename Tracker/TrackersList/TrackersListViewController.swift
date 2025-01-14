import UIKit

let mockedTrackers: [Tracker] = [
    .init(id: .init(), title: "Поливать растения", color: .Tracker._3, emoji: "🌺", schedule: .init(selectedDays: [.monday, .friday])),
    .init(id: .init(), title: "Бабушка прислала открытку в вотсапе", color: .Tracker._1, emoji: "💌", schedule: .init(selectedDays: [.sunday])),
    .init(id: .init(), title: "Свидания в апреле", color: .Tracker._0, emoji: "❤️", schedule: .init(selectedDays: [.monday, .tuesday, .wednesday, .thursday, .friday])),
]

let mockedCategories: [Category] = [
    .init(title: "Домашний уют", trackers: [mockedTrackers[0]]),
    .init(title: "Радостные мелочи", trackers: [mockedTrackers[1], mockedTrackers[2]]),
]

let mockedCompletedTrackers: [Record] = [
    .init(trackerID: mockedTrackers[0].id, date: "23.04.24")
]
    

final class TrackersListViewController: UIViewController {
    private var categories: [Category] =  mockedCategories
    private var completedTrackers: [Record] = mockedCompletedTrackers
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let columnsCount: CGFloat = 2
    private let cellGap: CGFloat = 9
    
    private lazy var emptyBlock: EmptyBlock = {
        let block = EmptyBlock()
        block.setLabel("Что будем отслеживать?")
        return block
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupConstraints()
        
        collectionView.register(TrackersListCell.self, forCellWithReuseIdentifier: TrackersListCell.reuseIdentifier)
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.reuseIdentifier)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setEmptyBlockVisible(categories.isEmpty)
    }
    
    func configureNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: "plus")
        navigationItem.leftBarButtonItem?.action = #selector(createTracker)
        navigationItem.leftBarButtonItem?.target = self
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        let datePickerBarButtonItem = UIBarButtonItem(customView: datePicker)
        datePickerBarButtonItem.customView?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        navigationItem.rightBarButtonItem = datePickerBarButtonItem
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = UISearchController()
}

    @objc
    func createTracker() {
        let view = NewTrackerViewController()
        let navController = UINavigationController(rootViewController: view)
        self.present(navController, animated: true)
    }
    
    private func setEmptyBlockVisible(_ isVisible: Bool) {
        emptyBlock.isHidden = !isVisible
    }
    
    private func setupConstraints() {
        [
            collectionView,
            emptyBlock,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            emptyBlock.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - extensions

extension TrackersListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // размеры для каждой ячейки
        let columnWidth = collectionView.bounds.width / columnsCount
        let paddingWidth = (columnsCount < 2 ? 0 : cellGap) / (columnsCount > 2 ? 1 : 2)
        return CGSize(width: columnWidth - paddingWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return cellGap
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
}

extension TrackersListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersListCell.reuseIdentifier, for: cellForItemAt)
        guard let trackersListCell = cell as? TrackersListCell else {
            return UICollectionViewCell()
        }
        configCell(trackersListCell, for: cellForItemAt)
        return trackersListCell
    }
    
    private func configCell(_ cell: TrackersListCell, for indexPath: IndexPath) {
        let tracker = categories[indexPath.section].trackers[indexPath.item]

        cell.setInfo(tracker)
        let completedRecord = completedTrackers.firstIndex(where: { $0.trackerID == tracker.id })
        cell.setCompleted(completedRecord != nil)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind != UICollectionView.elementKindSectionHeader {
            return UICollectionReusableView()
        }

        guard
            let collectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionHeader.reuseIdentifier, for: indexPath) as? CollectionHeader
        else {
            return UICollectionReusableView()
        }
        collectionHeader.titleLabel.text = categories[indexPath.section].title
        return collectionHeader
    }
}
