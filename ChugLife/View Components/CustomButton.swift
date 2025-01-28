import SwiftUI

struct CustomButton: View {
    var title: String
    var width: CGFloat
    var height: CGFloat
  var backgroundColor: Color = Color.buttonBackground
    var hoverEffect: Bool = true
  var foregroundColor: Color = Color.buttonText
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .frame(width: width, height: height)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
