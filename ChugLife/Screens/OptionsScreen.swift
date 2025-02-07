import SwiftUI
import SwiftUIGlass

struct OptionsScreen: View {
    // AppScreen’den Binding olarak alıyoruz.
    @Binding var editScreen: Bool
    @Binding var clearAlert: Bool
    @Binding var consumedWater: Double
    @Binding var quitFunction: Bool


    // Bu sayfayı kapatmak (dismiss) için Environment’den bir dismiss fonksiyonu alıyoruz.
    @Environment(\.dismiss) private var dismiss

    var body: some View {
      VStack(alignment: .center, spacing: 20) {
            Text("Options Screen")
                .font(.headline)
                .padding(.top, 20)

            // "Edit Information" butonu
            CustomButton(title: "Edit Information", width: 300, height: 40, hoverEffect: true) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    editScreen.toggle()
                }
                // Eğer butona basınca OptionsScreen'in kapanmasını istiyorsanız:
                dismiss()
            }
            .background(Color.buttonBackground)
            .foregroundColor(Color.buttonText)
            .cornerRadius(15)

            // "Clear Data" butonu
            CustomButton(title: "Clear Data", width: 300, height: 40, hoverEffect: true) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    clearAlert.toggle()
                }
            }
            .alert("Are you sure you want to clear your consumed water data?", isPresented: $clearAlert) {
                HStack {
                    Button("Yes") {
                        clearWaterData($consumedWater)
                        clearAlert = false
                        withAnimation(.easeInOut(duration: 0.5)) {
                            dismiss()
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        clearAlert = false
                    }
                }
            }
            .background(Color.buttonBackground)
            .foregroundColor(Color.buttonText)
            .cornerRadius(15)

        CustomButton(title: "Quit", width: 300, height: 40, hoverEffect: true) {
            withAnimation(.easeInOut(duration: 0.5)) {
              deleteUserData()
              quitFunction.toggle()
            }
            // Eğer butona basınca OptionsScreen'in kapanmasını istiyorsanız:
            dismiss()
        }
        .background(Color.buttonBackground)
        .foregroundColor(Color.buttonText)
        .cornerRadius(15)
        }
        // Yarım ekran olarak gösterilmesi (iOS 16+)
        .presentationDetents([.fraction(0.5)])
    }
}
