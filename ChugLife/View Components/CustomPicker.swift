import SwiftUI

struct CustomPicker: View {
    @Binding var selectedOption: String
    var options: [String]
  var selectedColor: Color = Color.buttonBackground
  var unselectedColor: Color = Color.glassBackground

    var body: some View {
        HStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                Text(option)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        ZStack {
                            if selectedOption == option {
                                selectedColor
                                    .cornerRadius(10)
                                    .transition(.scale)
                            } else {
                                unselectedColor.opacity(0.05)
                                    .cornerRadius(10)
                                    .transition(.opacity)
                            }
                        }
                    )
                    .foregroundColor(selectedOption == option ? Color.buttonText : Color.buttonText.opacity(0.7))
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            selectedOption = option
                        }
                    }
            }
        }
        .frame(width: 300, height: 40)
    }
}
