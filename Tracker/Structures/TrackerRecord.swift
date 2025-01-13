import Foundation


/// сущность для хранения записи о том, что определенный трекер был выполнен в определенную дату
struct TrackerRecord {
    let id: UUID
    let trackerId: UUID
    let date: Date
    
    init(
        trackerId: UUID,
        date: Date
    ) {
        self.id = UUID()
        self.trackerId = trackerId
        self.date = date
    }
}

