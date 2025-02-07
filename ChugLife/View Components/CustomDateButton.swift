import SwiftUI

struct CustomDateButton: View {
    var placeholder: String
    @Binding var date: Date?
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color = Color.glassBackground
    var cornerRadius: CGFloat = 7
    var foregroundColor: Color = Color.textField
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                // Eğer date nil veya bugünün tarihi ise placeholder göster
                if let selectedDate = date, !Calendar.current.isDateInToday(selectedDate) {
                    Text(selectedDate, formatter: dateFormatter)
                        .foregroundColor(foregroundColor)
                } else {
                    Text(placeholder)
                        .foregroundColor(foregroundColor.opacity(0.35))
                }
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(foregroundColor.opacity(0.35))
            }
            .padding()
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        }
    }

    // Yardımcı: Tarih formatlayıcı
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
