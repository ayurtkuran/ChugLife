import SwiftUI
import SwiftUIGlass

struct AppScreen: View {
    var name: String
    var surname: String
    var age: String
    var weight: String
    var gender: String

    let glasses: [GlassTypes] = [
        GlassTypes(name: "SmallGlass(200ml)💧", amount: 200),
        GlassTypes(name: "MediumGlass(400ml)💧💧", amount: 400),
        GlassTypes(name: "LargeGlass(600ml)💧💧💧", amount: 600),
    ]

    // consumedWater başlarken UserDefaults değerini okur.
    @State private var consumedWater: Double = UserDefaults.standard.double(forKey: "ConsumedWater")
    @State private var targetWater: Double = 0
    @State private var QuitFunction: Bool = false
    @State private var showDropdown: Bool = false
    @State private var customAmount: String = ""
    @State private var showError: Bool = false

    var areFieldsFilled: Bool {
        !customAmount.isEmpty
    }

    var body: some View {
        ZStack {
            if QuitFunction {
                // Burada WelcomeScreen() senin başka bir dosyada olmalı.
                WelcomeScreen()
                    .animation(.easeInOut(duration: 0.5), value: QuitFunction)
            } else {
                ZStack {
                    // GlassBackground() da başka bir dosyada/struct’ta
                    GlassBackground()
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Text("ChugLife")
                            .font(.system(size: 50, weight: .black, design: .rounded))
                            .foregroundColor(Color.textField.opacity(0.8))
                            .padding(.top, 40)

                        Text("Welcome back,")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.textField)

                        Text("\(name) \(surname)")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.textField)

                        Text("Daily Water Goal: \(Int(targetWater)) ml")
                            .font(.headline)
                            .foregroundColor(Color.textField.opacity(0.8))

                        ProgressBar(progress: $consumedWater, target: $targetWater)
                            .frame(height: 20)
                            .padding(.horizontal, 20)

                        Text("Consumed Water: \(Int(consumedWater)) ml")
                            .font(.headline)
                            .foregroundColor(Color.textField.opacity(0.8))

                        // CustomButton yine senin projendeki özel bir View
                        CustomButton(title: "Add Water", width: 300, height: 40, hoverEffect: true) {
                            withAnimation {
                                showDropdown.toggle()
                            }
                        }
                        .background(Color.buttonBackground)
                        .foregroundColor(Color.buttonText)
                        .cornerRadius(10)

                        if showDropdown {
                            VStack(spacing: 10) {
                                ForEach(glasses, id: \.name) { glass in
                                    CustomButton(title: glass.name, width: 300, height: 40, hoverEffect: true) {
                                        withAnimation {
                                            // Her su eklendiğinde consumedWater güncellenir ve UserDefaults’a kaydedilir
                                            consumedWater += Double(glass.amount)
                                            UserDefaults.standard.set(consumedWater, forKey: "ConsumedWater")
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                            withAnimation {
                                                showDropdown = false
                                            }
                                        }
                                    }
                                    .background(Color.buttonBackground)
                                    .foregroundColor(Color.buttonText)
                                    .cornerRadius(10)
                                }

                                HStack(spacing: 10) {
                                    // CustomTextField da senin özel bileşenin
                                    CustomTextField(placeholder: "Enter Custom Value", text: $customAmount, width: 200, height: 40)

                                    CustomButton(title: "Add", width: 80, height: 40, hoverEffect: true) {
                                        if areFieldsFilled {
                                            if let amount = Double(customAmount) {
                                                withAnimation {
                                                    consumedWater += amount
                                                    // Kaydet
                                                    UserDefaults.standard.set(consumedWater, forKey: "ConsumedWater")
                                                    customAmount = ""
                                                }
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                withAnimation {
                                                    showDropdown = false
                                                }
                                            }
                                        } else {
                                            showError = true
                                        }
                                    }
                                    .background(Color.buttonBackground)
                                    .foregroundColor(Color.buttonText)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal, 10)
                            }
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: showDropdown)
                            .padding(.horizontal, 20)
                        }

                        CustomButton(title: "Quit", width: 300, height: 40, hoverEffect: true) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                // Kullanıcı verilerini ve su miktarını sıfırla
                                deleteUserData()
                                UserDefaults.standard.set(0, forKey: "ConsumedWater")
                                consumedWater = 0

                                QuitFunction.toggle()
                            }
                        }
                        .background(Color.buttonBackground)
                        .foregroundColor(Color.buttonText)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .animation(.easeInOut(duration: 1.0), value: QuitFunction)
            }
        }
        .onAppear {
            // Hedef su miktarını hesapla
            targetWater = calculateDailyWaterNeed(weight: weight, gender: gender)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: {
            Text("Please fill the amount of water consumed!")
        }
    }
}

