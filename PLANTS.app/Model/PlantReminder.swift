import Foundation

// MARK: - Model: تذكير ري نبتة واحدة
struct PlantReminder: Identifiable, Equatable {
    let id: UUID
    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var waterAmount: WaterAmount
    var isDone: Bool                 // هل انسقت اليوم؟

    init(
        id: UUID = UUID(),
        name: String,
        room: Room = .bedroom,
        light: Light = .fullSun,
        wateringDays: WateringDays = .everyDay,
        waterAmount: WaterAmount = .ml20to50,
        isDone: Bool = false
    ) {
        self.id = id
        self.name = name
        self.room = room
        self.light = light
        self.wateringDays = wateringDays
        self.waterAmount = waterAmount
        self.isDone = isDone
    }
}

// بيانات تجريبية للمعاينة (Preview) والاختبار
extension PlantReminder {
    static let samples: [PlantReminder] = [
        PlantReminder(name: "Monstera", room: .kitchen),
        PlantReminder(name: "Pothos", room: .bedroom, isDone: true),
        PlantReminder(name: "Orchid", room: .livingRoom, wateringDays: .every3Days, waterAmount: .ml50to100),
        PlantReminder(name: "Spider", room: .kitchen, wateringDays: .onceAWeek)
    ]
}
