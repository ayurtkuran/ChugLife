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

    @State private var consumedWater: Double = UserDefaults.standard.double(forKey: "ConsumedWater")
    @State private var targetWater: Double = 0
    @State private var QuitFunction: Bool = false
    @State private var showDropdown: Bool = false
    @State private var customAmount: String = ""
    @State private var showError: Bool = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var isKeyboardVisible: Bool = false
    @State private var editScreen: Bool = false

    var areFieldsFilled: Bool {
        !customAmount.isEmpty
    }

    var body: some View {
        ZStack {
            if QuitFunction {
                WelcomeScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: QuitFunction)
            } else if editScreen {
                EditScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: editScreen)
            } else {
                ZStack {
                    GlassBackground()
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Text("ChugLife")
                            .font(.system(size: 50, weight: .black, design: .rounded))
                            .foregroundColor(Color.textField.opacity(0.8))
                            .padding(.top, 40)
                            .offset(y: isKeyboardVisible ? -keyboardHeight / 2 : 0)
                            .animation(.easeInOut(duration: 0.5), value: isKeyboardVisible)

                        Text("Welcome back")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.textField)

                        Text("\(name) \(surname)")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(Color.textField)

                        Text("Your Daily Water Goal: \(Int(targetWater)) ml")
                            .font(.headline)
                            .foregroundColor(Color.textField.opacity(0.8))

                        ProgressBar(progress: $consumedWater, target: $targetWater)
                            .frame(height: 20)
                            .padding(.horizontal, 20)

                        Text("Consumed Water: \(Int(consumedWater)) ml")
                            .font(.headline)
                            .foregroundColor(Color.textField.opacity(0.8))

                        CustomButton(title: "Add Water", width: 300, height: 40, hoverEffect: true) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                showDropdown.toggle()
                            }
                        }
                        .background(Color.buttonBackground)
                        .foregroundColor(Color.buttonText)
                        .cornerRadius(15)

                        if showDropdown {
                            VStack(spacing: 10) {
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

                                HStack(spacing: 10) {
                                    CustomTextField(placeholder: "Enter Custom Value", text: $customAmount, width: 200, height: 40)
                                        .keyboardType(.numberPad)

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
                            .animation(.easeInOut(duration: 0.5), value: showDropdown)
                            .padding(.horizontal, 20)
                        }

                        // DÜZELTİLMİŞ: "Edit Information" butonuna da aynı stil uygulanıyor
                        CustomButton(title: "Edit Information", width: 300, height: 40, hoverEffect: true) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                editScreen.toggle()
                            }
                        }
                        .background(Color.buttonBackground)
                        .foregroundColor(Color.buttonText)
                        .cornerRadius(15)

                        CustomButton(title: "Quit", width: 300, height: 40, hoverEffect: true) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                deleteUserData()
                                UserDefaults.standard.set(0, forKey: "ConsumedWater")
                                consumedWater = 0

                                QuitFunction.toggle()
                            }
                        }
                        .background(Color.buttonBackground)
                        .foregroundColor(Color.buttonText)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal, 20)
                }
                .animation(.easeInOut(duration: 0.5), value: QuitFunction)
            }
        }
        .onAppear {
            targetWater = calculateDailyWaterNeed(weight: weight, gender: gender)
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                keyboardHeight = keyboardFrame.height
                isKeyboardVisible = true
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                isKeyboardVisible = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: {
            Text("Please fill the amount of water consumed!")
        }
    }
}
