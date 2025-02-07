import SwiftUI

struct CustomDateButton: View {
    var placeholder: String
    @Binding var date : Date? // Optional<Date> olarak değiştirildi
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color = Color.glassBackground
    var cornerRadius: CGFloat = 7
    var foregroundColor: Color = Color.textField
    var action: () -> Void // Butona tıklandığında çalışacak aksiyon
    var body: some View {

        Button(action: action) { // Butonun action parametresi
            HStack {
                // Tarih seçilmemişse placeholder göster, seçilmişse tarihi göster
                if date == nil {
                    Text(placeholder)
                        .foregroundColor(.textField.opacity(0.35))
                } else {
                    Text(date!, formatter: dateFormatter)
                        .foregroundColor(.textField)
                }
                Spacer()
                Image(systemName: "calendar")
                    .foregroundColor(.textField.opacity(0.35))
            }
            .padding()
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
        }
    }

    // Tarih formatı için yardımcı
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}
