import SwiftUI

// MARK: - القائمة (Checklist): واجهة فقط، الأفعال تطلع للـ ViewModel عن طريق closures
struct PlantChecklist: View {
    let reminders: [PlantReminder]
    let onToggle: (PlantReminder) -> Void
    let onSelect: (PlantReminder) -> Void
    let onDelete: (PlantReminder) -> Void

    /// الصف المفتوح حاليًا (حالة واجهة بحتة، فتبقى هنا مو في الـ ViewModel)
    @State private var openRowID: UUID?

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(reminders) { reminder in
                    ChecklistRow(
                        reminder: reminder,
                        openRowID: $openRowID,
                        onToggle: { onToggle(reminder) },
                        onSelect: { onSelect(reminder) },
                        onDelete: {
                            openRowID = nil
                            onDelete(reminder)
                        }
                    )

                    Rectangle()
                        .fill(Color.appDivider)
                        .frame(height: 1)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.bottom, 100)
        }
    }
}

// MARK: - صف واحد: دائرة ✓ + غرفة + اسم + وسوم (يُسحب لليسار فيظهر زر الحذف)
struct ChecklistRow: View {
    let reminder: PlantReminder
    @Binding var openRowID: UUID?
    let onToggle: () -> Void
    let onSelect: () -> Void
    let onDelete: () -> Void

    /// مقدار الحركة أثناء السحب (يرجع صفر عند الإفلات)
    @State private var dragX: CGFloat = 0

    /// المسافة اللي ينسحب لها الصف لما ينفتح
    private let revealWidth: CGFloat = 90

    private var isOpen: Bool { openRowID == reminder.id }
    private var baseX: CGFloat { isOpen ? -revealWidth : 0 }
    private var offsetX: CGFloat { baseX + dragX }

    var body: some View {
        ZStack(alignment: .trailing) {
            deleteButton
            rowContent
                .offset(x: offsetX)
                .simultaneousGesture(swipeGesture)
        }
        .accessibilityAction(named: "Delete", onDelete)
    }

    // MARK: زر الحذف الأحمر (خلف الصف)
    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "trash")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 58, height: 44)
                .background(Capsule().fill(Color.appDanger))
        }
        .padding(.trailing, 20)
        .opacity(min(1, max(0, -offsetX / revealWidth)))
        .allowsHitTesting(isOpen)
    }

    // MARK: محتوى الصف
    private var rowContent: some View {
        HStack(spacing: 14) {

            // الدائرة: تبديل مسقية / غير مسقية
            Button(action: onToggle) {
                ZStack {
                    Circle().stroke(Color.gray, lineWidth: 1.5)
                    if reminder.isDone {
                        Circle().fill(Color.plantAccent)
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 26, height: 26)
                .padding(6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // باقي الصف: يفتح التعديل (أو يقفل الصف لو كان مفتوح)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Label("in \(reminder.room.rawValue)", systemImage: "location")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.gray)

                    Text(reminder.name)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(.white)

                    HStack(spacing: 8) {
                        tag("sun.max", reminder.light.rawValue)
                        tag("drop", reminder.waterAmount.rawValue)
                    }
                }
                .opacity(reminder.isDone ? 0.5 : 1)

                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isOpen {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                        openRowID = nil
                    }
                } else {
                    onSelect()
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }

    // MARK: حركة السحب
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                dragX = clamped(baseX + value.translation.width) - baseX
            }
            .onEnded { value in
                let finalX = clamped(baseX + value.translation.width)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                    openRowID = finalX < -revealWidth / 2 ? reminder.id : nil
                    dragX = 0
                }
            }
    }

    private func clamped(_ x: CGFloat) -> CGFloat {
        min(max(x, -revealWidth - 24), 0)
    }

    private func tag(_ icon: String, _ text: String) -> some View {
        Label(text, systemImage: icon)
            .font(.system(size: 13))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Capsule().fill(Color.appCard))
    }
}
