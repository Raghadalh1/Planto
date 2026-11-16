import Foundation

// MARK: - خيارات القوائم في شاشة Set Reminder
// (Model: بيانات فقط، بدون أي كود واجهة)

/// الغرفة
enum Room: String, CaseIterable {
    case bedroom    = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen    = "Kitchen"
    case balcony    = "Balcony"
    case bathroom   = "Bathroom"
}

/// الإضاءة
enum Light: String, CaseIterable {
    case fullSun    = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight   = "Low Light"

    /// اسم أيقونة SF Symbols لكل خيار
    var icon: String {
        switch self {
        case .fullSun:    return "sun.max"
        case .partialSun: return "sun.horizon"
        case .lowLight:   return "moon"
        }
    }
}

/// أيام الري
enum WateringDays: String, CaseIterable {
    case everyDay    = "Every day"
    case every2Days  = "Every 2 days"
    case every3Days  = "Every 3 days"
    case onceAWeek   = "Once a week"
    case every10Days = "Every 10 days"
    case every2Weeks = "Every 2 weeks"

    /// عدد الأيام بين كل سقاية (تستخدمها جدولة الإشعارات)
    var intervalInDays: Int {
        switch self {
        case .everyDay:    return 1
        case .every2Days:  return 2
        case .every3Days:  return 3
        case .onceAWeek:   return 7
        case .every10Days: return 10
        case .every2Weeks: return 14
        }
    }
}

/// كمية الماء
enum WaterAmount: String, CaseIterable {
    case ml20to50   = "20-50 ml"
    case ml50to100  = "50-100 ml"
    case ml100to200 = "100-200 ml"
    case ml200to300 = "200-300 ml"
}
