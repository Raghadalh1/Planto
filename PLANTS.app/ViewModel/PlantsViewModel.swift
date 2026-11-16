import Foundation
import Observation

// MARK: - أي شاشة منبثقة مفتوحة: إضافة جديد أو تعديل نبتة
enum ReminderSheet: Identifiable {
    case new
    case edit(PlantReminder)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let reminder):
            return reminder.id.uuidString
        }
    }
}

// MARK: - أي شاشة نعرض في الصفحة الرئيسية
enum ScreenState {
    case start          // أول مرة: Start your plant journey!
    case noReminders    // كان فيه تذكيرات وانحذفت كلها
    case allDone        // كل النباتات انسقت
    case list           // القائمة
}

// MARK: - ViewModel: عقل الصفحة الرئيسية (كل المنطق هنا، والواجهة تعرض بس)
@MainActor
@Observable
final class PlantsViewModel {

    // MARK: الحالة (State)
    /// القائمة: نقدر نقراها من برا، لكن ما نعدّلها إلا عن طريق الدوال تحت
    private(set) var reminders: [PlantReminder]
    private(set) var hasAddedReminderBefore: Bool
    /// الشاشة المنبثقة المفتوحة (nil = ما فيه شي مفتوح)
    var activeSheet: ReminderSheet?

    // MARK: الاعتمادات (Dependencies)
    private let notifications: any ReminderNotificationScheduling

    init(
        notifications: any ReminderNotificationScheduling = NotificationManager.shared,
        reminders: [PlantReminder] = []
    ) {
        self.notifications = notifications
        self.reminders = reminders
        self.hasAddedReminderBefore = !reminders.isEmpty
    }

    // MARK: قيم محسوبة (Derived State): الواجهة تقرأها وما تحسبها بنفسها

    var screenState: ScreenState {
        if reminders.isEmpty {
            return hasAddedReminderBefore ? .noReminders : .start
        }
        if reminders.allSatisfy(\.isDone) {
            return .allDone
        }
        return .list
    }

    var completedCount: Int {
        reminders.filter(\.isDone).count
    }

    /// نسبة الإنجاز من 0 إلى 1 (لشريط التقدّم)
    var progress: Double {
        reminders.isEmpty ? 0 : Double(completedCount) / Double(reminders.count)
    }

    var progressMessage: String {
        completedCount == 0
            ? "Your plants are waiting for a sip 💦"
            : "\(completedCount) of your plants feel loved today✨"
    }

    // MARK: أفعال المستخدم (Intents)

    func presentNewReminder() {
        activeSheet = .new
    }

    func presentEdit(_ reminder: PlantReminder) {
        activeSheet = .edit(reminder)
    }

    /// حفظ من شاشة Set Reminder: إذا النبتة موجودة نحدّثها، وإلا نضيفها
    func save(_ reminder: PlantReminder) {
        if reminders.contains(where: { $0.id == reminder.id }) {
            update(reminder)
        } else {
            add(reminder)
        }
    }

    func toggleDone(_ reminder: PlantReminder) {
        guard let index = index(of: reminder) else { return }
        reminders[index].isDone.toggle()
    }

    func delete(_ reminder: PlantReminder) {
        reminders.removeAll { $0.id == reminder.id }
        notifications.reschedule(reminders)
    }

    // MARK: أدوات داخلية

    private func add(_ reminder: PlantReminder) {
        reminders.append(reminder)
        hasAddedReminderBefore = true
        notifications.requestPermission()      // يطلب الإذن أول مرة
        notifications.reschedule(reminders)
    }

    private func update(_ reminder: PlantReminder) {
        guard let index = index(of: reminder) else { return }
        reminders[index] = reminder
        notifications.reschedule(reminders)
    }

    private func index(of reminder: PlantReminder) -> Int? {
        reminders.firstIndex { $0.id == reminder.id }
    }
}
