import SwiftUI

// MARK: - شاشة القائمة: شريط التقدّم + Checklist + زر +
struct TodayReminderView: View {
    let viewModel: PlantsViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                ProgressSection(
                    message: viewModel.progressMessage,
                    progress: viewModel.progress
                )

                PlantChecklist(
                    reminders: viewModel.reminders,
                    onToggle: { reminder in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.toggleDone(reminder)
                        }
                    },
                    onSelect: { reminder in
                        viewModel.presentEdit(reminder)
                    },
                    onDelete: { reminder in
                        withAnimation(.easeInOut(duration: 0.25)) {
                            viewModel.delete(reminder)
                        }
                    }
                )
            }

            AddButton {
                viewModel.presentNewReminder()
            }
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
            TodayReminderView(
                viewModel: PlantsViewModel(
                    notifications: NoopNotificationScheduler(),
                    reminders: PlantReminder.samples
                )
            )
        }
    }
    .preferredColorScheme(.dark)
}
