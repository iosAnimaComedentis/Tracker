import Foundation


/// сущность для хранения категории трекеров
struct TrackerCategory {
    let id: UUID
    let title: String
    let trackers: [Tracker]
    
    init(
        title: String,
        trackers: [Tracker]
    ) {
        self.title = title
        self.id = UUID()
        self.trackers = trackers
    }
}
