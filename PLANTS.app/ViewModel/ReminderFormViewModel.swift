import Foundation
import Observation

// MARK: - ViewModel: حالة نموذج Set Reminder (إضافة أو تعديل)
@Observable
final class ReminderFormViewModel {

    // الحقول اللي ترتبط بالواجهة
    var name: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var waterAmount: WaterAmount

    /// nil = إضافة جديد | غير nil = تعديل نبتة موجودة
    private let original: PlantReminder?

    init(reminder: PlantReminder? = nil) {
        original = reminder
        name = reminder?.name ?? ""
        room = reminder?.room ?? .bedroom
        light = reminder?.light ?? .fullSun
        wateringDays = reminder?.wateringDays ?? .everyDay
        waterAmount = reminder?.waterAmount ?? .ml20to50
    }

    var isEditing: Bool {
        original != nil
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// زر ✓ ما يشتغل إلا لو الاسم مو فاضي
    var canSave: Bool {
        !trimmedName.isEmpty
    }

    /// يبني التذكير النهائي. في التعديل يبقى نفس الـ id ونفس حالة التأشير
    func makeReminder() -> PlantReminder {
        PlantReminder(
            id: original?.id ?? UUID(),
            name: trimmedName,
            room: room,
            light: light,
            wateringDays: wateringDays,
            waterAmount: waterAmount,
            isDone: original?.isDone ?? false
        )
    }
}
