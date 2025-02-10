import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var width: CGFloat
    var height: CGFloat
    var backgroundColor: Color = Color.gray.opacity(0.2)
    var cornerRadius: CGFloat = 7
    var foregroundColor: Color = Color.black

    @FocusState private var isFocused: Bool // Klavye durumunu kontrol etmek için

    var body: some View {
        TextField(placeholder, text: $text)
            .focused($isFocused) // TextField'in odak durumunu bağlama
            .padding()
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .foregroundColor(foregroundColor)
            .font(.body)
            .disableAutocorrection(true)
            .textFieldStyle(PlainTextFieldStyle())
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()// Boşluk ekleyerek butonu sağa taşır
                    Button("OK") {
                        isFocused = false // Klavyeyi kapatır
                    }
      }
            }
    }
}
