import SwiftUI
import SwiftUIGlass

struct AppScreen: View {
    var name: String
    var surname: String
    var birthDate: Date
    var weight: String
    var gender: String

    let glasses: [GlassTypes] = [
        GlassTypes(name: "Small Bottle (500ml)", amount: 500),
        GlassTypes(name: "Medium Bottle (1L)", amount: 1000),
        GlassTypes(name: "Large Bottle (1.5L)", amount: 1500),
    ]

    @State private var consumedWater: Double = UserDefaults.standard.double(forKey: "ConsumedWater")
    @State private var targetWater: Double = 0
    @State private var quitFunction: Bool = false
    @State private var showDropdown: Bool = false
    @State private var customAmount: String = ""
    @State private var showError: Bool = false
    @State private var editScreen: Bool = false
    @State private var clearAlert: Bool = false
    @State private var showMenu: Bool = false
    @State private var scrollToBottom: Bool = false

    var areFieldsFilled: Bool {
        !customAmount.isEmpty
    }

    var body: some View {
        ZStack {
            if quitFunction {
                WelcomeScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: quitFunction)
            } else if editScreen {
                EditScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: editScreen)
            } else {
                ZStack {
                    GlassBackground()
                        .edgesIgnoringSafeArea(.all)

                    // Main content inside ScrollView
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 20) {
                              HStack{

                                Button(action: {
                                    withAnimation {
                                        showMenu.toggle()
                                    }
                                }, label: {
                                    Image(systemName: "line.horizontal.3")
                                    .font(.title)
                                        .padding()
                                        .foregroundColor(Color.textField)
                                })
                                
                                Spacer()
                              }


                                Text("ChugLife")
                                  .font(.system(size: 50, weight: .black, design: .rounded))
                                  .foregroundColor(Color.textField.opacity(0.8))
                                  .padding(.top, 40)
                                  .id("Title")


                                Text("Welcome Back")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.textField)

                                Text("\(name) \(surname)")
                                    .textCase(.uppercase)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
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
                                                .id("CustomTextField") // ScrollView'da bu alana odaklanmak için

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
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40) // Bottom padding for better spacing
                        }
                        .onChange(of: scrollToBottom) { _, newValue in
                            if newValue {
                                // Klavye açıldıktan 0.2 saniye sonra en alta kaydır
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        proxy.scrollTo("CustomTextField", anchor: .bottom)
                                    }
                                }
                            }
                        }
                    }


                }
            }
        }
        .onAppear {
            if isNewDayComparedToLastSavedDate() {
                // Yeni günse, su tüketimini animasyonla sıfırla
                withAnimation(.easeInOut(duration: 0.5)) {
                    consumedWater = 0
                }
                UserDefaults.standard.set(consumedWater, forKey: "ConsumedWater")
                UserDefaults.standard.set(Date(), forKey: "LastResetDate")
            }
            targetWater = calculateDailyWaterNeed(weight: weight, gender: gender)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            // Klavye açıldığında scrollToBottom'ı tetikle
            scrollToBottom = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            // Klavye kapandığında scrollToBottom'ı sıfırla
            scrollToBottom = false
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { showError = false }
        } message: {
            Text("Please fill the amount of water consumed!")
        }
        // Menu screen'in .sheet ile sunulması
        .sheet(isPresented: $showMenu) {
            OptionsScreen(
                editScreen: $editScreen,
                clearAlert: $clearAlert,
                consumedWater: $consumedWater,
                quitFunction: $quitFunction
            )
        }
    }

    func calculateAge() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        return ageComponents.year ?? 0
    }

    func clearWaterData(_ consumed: Binding<Double>) {
        consumed.wrappedValue = 0
        UserDefaults.standard.set(consumed.wrappedValue, forKey: "ConsumedWater")
    }
}
