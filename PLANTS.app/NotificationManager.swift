import Foundation
import UserNotifications

// MARK: - العقد: كل اللي يحتاجه الـ ViewModel من خدمة الإشعارات
// (نستخدم Protocol عشان نقدر نبدّلها بنسخة وهمية في المعاينة والاختبار)
@MainActor
protocol ReminderNotificationScheduling {
    func requestPermission()
    func reschedule(_ reminders: [PlantReminder])
}

/// نسخة وهمية ما تسوي شي (للمعاينة والاختبارات)
struct NoopNotificationScheduler: ReminderNotificationScheduling {
    func requestPermission() { }
    func reschedule(_ reminders: [PlantReminder]) { }
}

// MARK: - الخدمة الفعلية: طلب الإذن + جدولة تذكيرات الري
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ReminderNotificationScheduling {

    static let shared = NotificationManager()

    // وقت التذكير اليومي (9:00 صباحًا)
    private let reminderHour = 9
    private let reminderMinute = 0

    // بداية هوية كل إشعار ري، نستخدمها عشان نحذف إشعاراتنا القديمة بس
    private let idPrefix = "water-"

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - طلب الإذن
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error {
                print("Notification permission error:", error)
            }
            print("Notifications allowed:", granted)
        }
    }

    // MARK: - جدولة إشعارات كل النباتات
    func reschedule(_ reminders: [PlantReminder]) {
        let center = UNUserNotificationCenter.current()

        center.getPendingNotificationRequests { [weak self] requests in
            guard let self else { return }

            // نحذف إشعارات الري القديمة (ونترك أي إشعار ثاني مثل التجربة)
            let oldIDs = requests.map(\.identifier).filter { $0.hasPrefix(self.idPrefix) }
            center.removePendingNotificationRequests(withIdentifiers: oldIDs)

            guard !reminders.isEmpty else { return }

            // النظام يحتفظ بـ 64 إشعار كحد أقصى، فنوزعها على النباتات
            let perPlant = max(1, min(14, 60 / reminders.count))

            let calendar = Calendar.current
            let now = Date()

            // أول موعد: اليوم الساعة 9، وإذا فات الوقت فبكرة
            guard var firstFire = calendar.date(
                bySettingHour: self.reminderHour,
                minute: self.reminderMinute,
                second: 0,
                of: now
            ) else { return }

            if firstFire <= now {
                firstFire = calendar.date(byAdding: .day, value: 1, to: firstFire) ?? firstFire
            }

            for reminder in reminders {
                let step = reminder.wateringDays.intervalInDays

                for k in 0..<perPlant {
                    guard let fireDate = calendar.date(byAdding: .day, value: k * step, to: firstFire) else { continue }

                    let components = calendar.dateComponents(
                        [.year, .month, .day, .hour, .minute],
                        from: fireDate
                    )
                    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

                    let request = UNNotificationRequest(
                        identifier: "\(self.idPrefix)\(reminder.id.uuidString)-\(k)",
                        content: self.makeContent(),
                        trigger: trigger
                    )
                    center.add(request)
                }
            }
        }
    }

    // MARK: - إشعار تجريبي بعد 5 ثواني (للتجربة بس)
    func sendTest() {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "test", content: makeContent(), trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    // MARK: - شكل الإشعار
    nonisolated private func makeContent() -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your plant"
        content.sound = .default
        content.threadIdentifier = "watering"
        return content
    }

    // MARK: - يظهر الإشعار وهو التطبيق مفتوح
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        [.banner, .sound]
    }
}
