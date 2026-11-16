import SwiftUI

// MARK: - شاشة "No reminders set yet.."
struct NoRemindersView: View {
    let onAdd: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Text("No reminders set yet..")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            AddButton(action: onAdd)
                .padding(.trailing, 24)
                .padding(.bottom, 24)
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 0) {
            PlantsHeader()
            NoRemindersView { }
        }
    }
    .preferredColorScheme(.dark)
}
