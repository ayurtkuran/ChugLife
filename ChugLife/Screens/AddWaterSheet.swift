import SwiftUI

struct AddWaterSheet: View {
    @Binding var showDropdown: Bool           // Sheet’i kapatmak için
    @Binding var consumedWater: Double
    @Binding var customAmount: String
    @Binding var showError: Bool
    var glasses: [GlassTypes]

    // TextField boş mu dolu mu diye kontrol ediyoruz.
    var areFieldsFilled: Bool {
        !customAmount.isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Water")
                .font(.headline)
                .padding(.top, 10)

            // Özel miktar giriş alanı + "Add" butonu
            HStack(alignment: .center, spacing: 10) {
                CustomTextField(
                    placeholder: "Enter Custom Value",
                    text: $customAmount,
                    width: 200,
                    height: 40,
                    keyboardType: .numberPad
                )

                CustomButton(title: "Add", width: 80, height: 40, hoverEffect: true) {
                    if areFieldsFilled {
                        if let amount = Double(customAmount) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                consumedWater += amount
                                UserDefaults.standard.set(consumedWater, forKey: "ConsumedWater")
                                customAmount = ""
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showDropdown = false
                            }
                        }
                    } else {
                        // Eğer TextField boşsa hata göstermek için
                        showError = true
                    }
                }
                .background(Color.buttonBackground)
                .foregroundColor(Color.buttonText)
                .cornerRadius(10)
            }
            .frame(height: 40)
            .padding(.horizontal, 10)

            // Hazır şişe seçenekleri
            ForEach(glasses, id: \.name) { glass in
                CustomButton(title: glass.name, width: 300, height: 40, hoverEffect: true) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        consumedWater += Double(glass.amount)
                        UserDefaults.standard.set(consumedWater, forKey: "ConsumedWater")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showDropdown = false
                        }
                    }
                }
                .background(Color.buttonBackground)
                .foregroundColor(Color.buttonText)
                .cornerRadius(10)
            }
            .frame(width: 300, height: 40)

            Spacer()
        }
        .padding()
        // "Lütfen miktar girin" uyarısı
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: {
            Text("Please fill the amount of water consumed!")
        }
    }
}
