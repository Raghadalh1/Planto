import SwiftUI

// MARK: - الشاشة الرئيسية: تختار أي واجهة تعرض حسب حالة الـ ViewModel
struct MyPlantsView: View {

    /// الـ ViewModel الوحيد للصفحة، وهذي الـ View هي اللي تملكه
    @State private var viewModel = PlantsViewModel()

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                PlantsHeader()
                content
            }
            .animation(.easeInOut(duration: 0.3), value: viewModel.screenState)
        }
        .preferredColorScheme(.dark)
        .sheet(item: $viewModel.activeSheet) { sheet in
            sheetContent(for: sheet)
        }
    }

    // MARK: - اختيار الشاشة (الواجهة ما تقرر، الـ ViewModel هو اللي يقرر)
    @ViewBuilder
    private var content: some View {
        switch viewModel.screenState {
        case .start:
            StartView {
                viewModel.presentNewReminder()
            }

        case .noReminders:
            NoRemindersView {
                viewModel.presentNewReminder()
            }

        case .allDone:
            AllDoneView {
                viewModel.presentNewReminder()
            }

        case .list:
            TodayReminderView(viewModel: viewModel)
        }
    }

    // MARK: - محتوى الشاشة المنبثقة
    @ViewBuilder
    private func sheetContent(for sheet: ReminderSheet) -> some View {
        switch sheet {
        case .new:
            SetReminderView(
                onSave: { reminder in
                    viewModel.save(reminder)
                }
            )

        case .edit(let reminder):
            SetReminderView(
                reminder: reminder,
                onSave: { updated in
                    viewModel.save(updated)
                },
                onDelete: {
                    viewModel.delete(reminder)
                }
            )
        }
    }
}

#Preview {
    MyPlantsView()
}
