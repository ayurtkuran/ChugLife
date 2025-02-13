import SwiftUI
import SwiftUIGlass

struct OptionsScreen: View {
    @Binding var editScreen: Bool
    @Binding var clearAlert: Bool
    @Binding var consumedWater: Double
    @Binding var quitFunction: Bool

    // Menüyü kapatıp açmak için
    @Binding var showMenu: Bool

    var body: some View {
        // Ana zemin
        ZStack(alignment: .leading) {
            // Menü arka plan rengi
            Color(.systemGray6)
                .edgesIgnoringSafeArea(.all)

            // Menü içeriği
            VStack(alignment: .leading, spacing: 20) {
                Text("Options Screen")
                    .font(.headline)
                    .padding(.top, 40)
                    .padding(.leading, 20)

                Spacer()

                // "Edit Information" butonu
                CustomButton(title: "Edit Information", width: 250, height: 40, hoverEffect: true) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        editScreen.toggle()
                        showMenu = false
                    }
                }
                .background(Color.buttonBackground)
                .foregroundColor(Color.buttonText)
                .cornerRadius(15)
                .padding(.leading, 20)

                // "Clear Data" butonu
                CustomButton(title: "Clear Data", width: 250, height: 40, hoverEffect: true) {
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
                                showMenu = false
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
                .padding(.leading, 20)

                // "Quit" butonu
                CustomButton(title: "Quit", width: 250, height: 40, hoverEffect: true) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        deleteUserData()
                        quitFunction.toggle()
                        showMenu = false
                    }
                }
                .background(Color.buttonBackground)
                .foregroundColor(Color.buttonText)
                .cornerRadius(15)
                .padding(.leading, 20)

                Spacer()
            }
            .frame(width: 300, alignment: .leading) // Menü genişliği
        }
        .frame(width: 300, alignment: .leading)        // Menüyü sola sabitle
        .transition(.move(edge: .leading))            // Soldan kayarak açılma animasyonu
        .animation(.easeInOut(duration: 0.5), value: showMenu)
    }

    // Yardımcı fonksiyonlar
    func clearWaterData(_ consumed: Binding<Double>) {
        consumed.wrappedValue = 0
        UserDefaults.standard.set(consumed.wrappedValue, forKey: "ConsumedWater")
    }

    func deleteUserData() {
        UserDefaults.standard.removeObject(forKey: "ConsumedWater")
    }
}
