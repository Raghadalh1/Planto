import SwiftUI

// MARK: - البطاقة الرمادية الغامقة اللي تحتوي الصفوف
struct SettingsCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color.appCard)
        )
    }
}

// MARK: - الخط الفاصل بين الصفوف
struct RowDivider: View {
    var body: some View {
        Rectangle()
            .fill(Color.appDivider)
            .frame(height: 1)
            .padding(.horizontal, 16)
    }
}

// MARK: - صف قائمة: أيقونة + عنوان + القيمة المختارة، وبالضغط تنفتح الخيارات
struct SelectionRow<Option: Hashable>: View {
    let icon: String
    let title: String
    let options: [Option]
    @Binding var selection: Option
    let text: (Option) -> String
    var optionIcon: ((Option) -> String)? = nil

    var body: some View {
        Menu {
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    if let optionIcon {
                        Label(text(option), systemImage: optionIcon(option))
                            .tag(option)
                    } else {
                        Text(text(option))
                            .tag(option)
                    }
                }
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .frame(width: 24)
                    .foregroundStyle(.white)

                Text(title)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)

                Spacer()

                Text(text(selection))
                    .font(.system(size: 18))
                    .foregroundStyle(Color.gray)

                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.gray)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
    }
}
