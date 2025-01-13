import Foundation
//TODO: - Добавить цвета. Возможно потребуется enum для ограничения эмодзи
enum TrackerColor: String {
    case red = "red"
}

/// сущность для хранения информации о Привычке или Нерегулярном событии
struct Tracker {
    let id: UUID
    let name: String
    let color: TrackerColor
    let emoji: String
    let timetable: [Date]
    
    init(
        name: String,
        color: TrackerColor,
        emoji: String, timetable: [Date]
    ) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.timetable = timetable
    }
}

