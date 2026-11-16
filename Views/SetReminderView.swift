import SwiftUI

// MARK: - شاشة Set Reminder (إضافة تذكير جديد أو تعديل تذكير موجود)
struct SetReminderView: View {

    @Environment(\.dismiss) private var dismiss

    /// حالة النموذج كلها في الـ ViewModel، والواجهة تربط الحقول فيه
    @State private var form: ReminderFormViewModel
    @State private var showDeleteConfirm = false
    @FocusState private var nameFocused: Bool

    private let onSave: (PlantReminder) -> Void
    private let onDelete: (() -> Void)?

    init(
        reminder: PlantReminder? = nil,
        onSave: @escaping (PlantReminder) -> Void = { _ in },
        onDelete: (() -> Void)? = nil
    ) {
        _form = State(initialValue: ReminderFormViewModel(reminder: reminder))
        self.onSave = onSave
        self.onDelete = onDelete
    }

    var body: some View {
        ZStack {
            Color.appSheet.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                ScrollView {
                    VStack(spacing: 28) {
                        nameField
                        roomAndLightCard
                        wateringCard

                        // زر الحذف يظهر فقط عند تعديل تذكير موجود
                        if form.isEditing {
                            deleteButton
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 36)
                    .padding(.bottom, 40)
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .preferredColorScheme(.dark)
        .presentationCornerRadius(40)
        .presentationDragIndicator(.hidden)
        .confirmationDialog(
            "Delete Reminder",
            isPresented: $showDeleteConfirm,
            titleVisibility: .hidden
        ) {
            Button("Delete Reminder", role: .destructive) {
                onDelete?()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        }
    }

    // MARK: - الشريط العلوي: ✕  Set Reminder  ✓
    private var topBar: some View {
        ZStack {
            Text("Set Reminder")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)

            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(Circle().fill(Color(white: 0.22)))
                        .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
                }

                Spacer()

                Button {
                    onSave(form.makeReminder())
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 46, height: 46)
                        .background(Circle().fill(Color.plantGreen))
                        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                }
                .disabled(!form.canSave)
                .opacity(form.canSave ? 1 : 0.4)
            }
        }
    }

    // MARK: - خانة اسم النبتة
    private var nameField: some View {
        HStack(spacing: 10) {
            Text("Plant Name")
                .font(.system(size: 18))
                .foregroundStyle(.white)

            TextField(
                "",
                text: $form.name,
                prompt: Text("Pothos").foregroundStyle(Color.gray.opacity(0.7))
            )
            .font(.system(size: 18))
            .foregroundStyle(.white)
            .tint(Color.plantAccent)
            .textInputAutocapitalization(.words)
            .focused($nameFocused)
        }
        .padding(.horizontal, 20)
        .frame(height: 54)
        .background(Capsule().fill(Color.appCard))
    }

    // MARK: - بطاقة: الغرفة + الإضاءة
    private var roomAndLightCard: some View {
        SettingsCard {
            SelectionRow(
                icon: "location",
                title: "Room",
                options: Room.allCases,
                selection: $form.room,
                text: \.rawValue
            )
            RowDivider()
            SelectionRow(
                icon: "sun.max",
                title: "Light",
                options: Light.allCases,
                selection: $form.light,
                text: \.rawValue,
                optionIcon: \.icon
            )
        }
    }

    // MARK: - بطاقة: أيام الري + كمية الماء
    private var wateringCard: some View {
        SettingsCard {
            SelectionRow(
                icon: "drop",
                title: "Watering Days",
                options: WateringDays.allCases,
                selection: $form.wateringDays,
                text: \.rawValue
            )
            RowDivider()
            SelectionRow(
                icon: "drop",
                title: "Water",
                options: WaterAmount.allCases,
                selection: $form.waterAmount,
                text: \.rawValue
            )
        }
    }

    // MARK: - زر Delete Reminder
    private var deleteButton: some View {
        Button(role: .destructive) {
            showDeleteConfirm = true
        } label: {
            Label("Delete Reminder", systemImage: "trash")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.red)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Capsule().fill(Color.appCard))
        }
        .padding(.top, 12)
    }
}

#Preview("New") {
    SetReminderView()
}

#Preview("Edit") {
    SetReminderView(
        reminder: PlantReminder.samples[0],
        onSave: { _ in },
        onDelete: { }
    )
}
