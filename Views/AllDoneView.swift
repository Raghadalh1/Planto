import SwiftUI

// MARK: - شاشة "All Done! 🎉" (تظهر لما كل النباتات تتأشر)
struct AllDoneView: View {
    let onAdd: () -> Void

    // الصورة: ضيفي صورة النبتة الغامزة في Assets باسم "plantDone"
    // ولو ما انضافت، نستخدم صورة شاشة البداية بدالها
    private var imageName: String {
        UIImage(named: "plantDone") != nil ? "plantDone" : "plants 1"
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color(white: 0.07))
                        .frame(width: 270, height: 270)

                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                }
                .accessibilityHidden(true)

                Text("All Done! 🎉")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.top, 28)

                Text("All Reminders Completed")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.gray)
                    .padding(.top, 8)

                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)

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
            AllDoneView { }
        }
    }
    .preferredColorScheme(.dark)
}
