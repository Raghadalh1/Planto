import SwiftUI

// MARK: - العنوان "My Plants 🌱" + الخط الفاصل (مشترك بين كل الشاشات)
struct PlantsHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.top, 24)

            Rectangle()
                .fill(Color.white.opacity(0.18))
                .frame(height: 1)
                .padding(.leading, 20)
        }
    }
}

// MARK: - زر + الأخضر الدائري
struct AddButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.plantGreen))
                .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
        }
        .accessibilityLabel("Add reminder")
    }
}
