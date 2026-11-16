import SwiftUI

// MARK: - ألوان التطبيق في مكان واحد
extension Color {
    /// الأخضر الفاتح: المؤشر، شريط التقدّم، الدائرة المؤشرة
    static let plantAccent = Color(red: 0.17, green: 0.82, blue: 0.63)
    /// الأخضر الغامق: الأزرار
    static let plantGreen = Color(red: 0.16, green: 0.50, blue: 0.40)
    /// خلفية البطاقات والخانات والوسوم
    static let appCard = Color(white: 0.17)
    /// خلفية شاشة Set Reminder
    static let appSheet = Color(white: 0.12)
    /// الخطوط الفاصلة
    static let appDivider = Color.white.opacity(0.12)
    /// الأحمر (الحذف)
    static let appDanger = Color(red: 0.93, green: 0.33, blue: 0.36)
}
