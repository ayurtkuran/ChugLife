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
    @State private var showCelebrationAnimation: Bool = false

    var body: some View {
        ZStack {
            if quitFunction {
                // 1) WelcomeScreen'e dönüldüğünde
                WelcomeScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: quitFunction)
            } else if editScreen {
                // 2) EditScreen'e gidildiğinde
                EditScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: editScreen)
            } else {
                // 3) Normal AppScreen içeriği
                ZStack {
                    GlassBackground()
                        .edgesIgnoringSafeArea(.all)

                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 20) {
                                // Menu butonunu üst tarafta konumlandırıyoruz
                                HStack {
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

                                // İlerleme çubuğu
                                ProgressBar(progress: $consumedWater, target: $targetWater)
                                    .frame(height: 20)
                                    .padding(.horizontal, 20)

                                Text("Consumed Water: \(Int(consumedWater)) ml")
                                    .font(.headline)
                                    .foregroundColor(Color.textField.opacity(0.8))

                                // Hedefe ulaşıldıysa
                                if consumedWater >= targetWater {
                                    Text("You have reached your target! 🎉")
                                        .font(.headline)
                                        .foregroundColor(.textField)
                                        .padding(.top, 10)
                                }

                                // "Add Water" butonu
                                CustomButton(title: "Add Water", width: 300, height: 40, hoverEffect: true) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showDropdown.toggle()
                                    }
                                }
                                .background(Color.buttonBackground)
                                .foregroundColor(Color.buttonText)
                                .cornerRadius(15)
                                .padding(.bottom, 50)
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 40)
                        }
                    }

                    // Kutlama animasyonu
                    if showCelebrationAnimation {
                        LottieView(filename: "Animation - 1739229267569", loopMode: .playOnce)
                            .frame(width: 50, height: 50)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showCelebrationAnimation = false
                                    }
                                }
                            }
                    }
                }
            }

            // Side Menu (OptionsScreen)
            if showMenu {
                // Karartma alanı
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showMenu = false
                        }
                    }

                // Menünün kendisi
                HStack(spacing: 0) {
                    OptionsScreen(
                        editScreen: $editScreen,
                        clearAlert: $clearAlert,
                        consumedWater: $consumedWater,
                        quitFunction: $quitFunction,
                        showMenu: $showMenu
                    )
                    Spacer() // Boşluk ekleyerek menüyü solda sabit tutuyoruz
                }
                .transition(.move(edge: .leading))
                .animation(.easeInOut(duration: 0.3), value: showMenu)
                .edgesIgnoringSafeArea(.all)
            }
        }
        // Sheet için
        .sheet(isPresented: $showDropdown) {
            AddWaterSheet(
                showDropdown: $showDropdown,
                consumedWater: $consumedWater,
                customAmount: $customAmount,
                showError: $showError,
                glasses: glasses
            )
            .presentationDetents([.fraction(0.5), .large])
            .presentationDragIndicator(.visible)
        }
        // On Appear
        .onAppear {
            checkForPermission()
            if isNewDayComparedToLastSavedDate() {
                withAnimation(.easeInOut(duration: 0.5)) {
                    consumedWater = 0
                }
                UserDefaults.standard.set(consumedWater, forKey: "ConsumedWater")
                UserDefaults.standard.set(Date(), forKey: "LastResetDate")
            }
            targetWater = calculateDailyWaterNeed(weight: weight, gender: gender)
        }
        // Kutlama animasyonu tetikleme
        .onChange(of: consumedWater) { oldValue, newValue in
            if newValue >= targetWater && !showCelebrationAnimation {
                showCelebrationAnimation = true
            }
        }
    }

    // Yardımcı fonksiyonlar
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

    func calculateDailyWaterNeed(weight: String, gender: String) -> Double {
        // Örnek hesaplama:
        let w = Double(weight) ?? 0
        // Basit formül örneği
        let baseNeed = w * 30.0
        return baseNeed
    }

    func checkForPermission() {
        // Örnek fonksiyon, notification veya health kit izni vs.
    }

    func isNewDayComparedToLastSavedDate() -> Bool {
        // Tarih kontrolü vs.
        return false
    }
}
