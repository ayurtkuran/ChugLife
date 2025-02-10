import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var width: CGFloat
    var height: CGFloat
  var backgroundColor: Color = Color.glassBackground
    var cornerRadius: CGFloat = 7
  var foregroundColor: Color = Color.textField
    var keyboardType: UIKeyboardType = .default // Klavye tipini belirlemek için

    @FocusState private var isFocused: Bool // Klavye durumunu kontrol etmek için

    var body: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused) // TextField'in odak durumunu bağlama
            .keyboardType(keyboardType) // Klavye tipini ayarla
            .padding()
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .foregroundColor(foregroundColor)
            .font(.body)
            .disableAutocorrection(true)
            .textFieldStyle(PlainTextFieldStyle())
            .toolbar {
                // Sadece numberPad klavye tipi ve odaklanma durumunda OK butonu gösterilsin
                if keyboardType == .numberPad && isFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("OK") {
                            isFocused = false // Klavyeyi kapatır
                        }
                    }
                }
            }
    }
}
