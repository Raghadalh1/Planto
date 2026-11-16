import SwiftUI

struct StartView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            Image("plants")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .accessibilityLabel("Cute potted plant")

            Text("Start your plant journey!")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.white)
                .padding(.top, 32)

            Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                .font(.system(size: 17))
                .foregroundStyle(Color.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 60)
                .padding(.top, 12)

            Button(action: onStart) {
                Text("Set Plant Reminder")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 280, height: 56)
                    .background(
                        Capsule().fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.22, green: 0.55, blue: 0.44),
                                    Color(red: 0.14, green: 0.41, blue: 0.33)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    )
                    .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
            }
            .padding(.top, 90)

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack(alignment: .leading, spacing: 0) {
            PlantsHeader()
            StartView { }
        }
    }
    .preferredColorScheme(.dark)
}
