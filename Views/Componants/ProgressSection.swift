import SwiftUI

// MARK: - الرسالة + شريط التقدّم (واجهة فقط، تستقبل النص والنسبة جاهزين)
struct ProgressSection: View {
    let message: String
    let progress: Double      // من 0 إلى 1

    var body: some View {
        VStack(spacing: 16) {
            Text(message)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            // المسار الرمادي + التعبئة الخضراء
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(white: 0.2))
                    Capsule()
                        .fill(Color.plantAccent)
                        .frame(width: geo.size.width * progress)
                        .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding(.horizontal, 28)
        .padding(.top, 28)
        .padding(.bottom, 20)
    }
}
