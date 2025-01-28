import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var width: CGFloat
    var height: CGFloat
  var backgroundColor: Color = Color.glassBackground
    var cornerRadius: CGFloat = 7
  var foregroundColor: Color = Color.textField

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .frame(width: width, height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .foregroundColor(foregroundColor)
            .font(.body)
            .disableAutocorrection(true)
            .textFieldStyle(PlainTextFieldStyle())
    }
}
