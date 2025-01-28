import SwiftUI
import SwiftUIGlass

struct AppScreen: View {
    var name: String
    var surname: String
    var age: String
    var weight: String
    var gender: String

    @State private var consumedWater: Double = 0
    @State private var targetWater: Double = 0
    @State private var QuitFunction: Bool = false

    var body: some View {
        ZStack {
            if QuitFunction {
                WelcomeScreen()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: QuitFunction)
            } else {
                ZStack {
                    GlassBackground()
                    .edgesIgnoringSafeArea(.all)

                    GlassPane(cornerRadius: 20, opacity: 0.15, shadowRadius: 10) {
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

                            CustomButton(title: "Add Water", width: 300, height: 40, hoverEffect: true) {
                                consumedWater += 200
                            }
                            .background(Color.buttonBackground)
                            .foregroundColor(Color.buttonText)
                            .cornerRadius(10)

                            CustomButton(title: "Quit", width: 300, height: 40, hoverEffect: true) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    deleteUserData()
                                    QuitFunction.toggle()
                                }
                            }
                            .background(Color.buttonBackground)
                            .foregroundColor(Color.buttonText)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 20))
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 1.0), value: QuitFunction)
            }
        }
        .onAppear {
            targetWater = calculateDailyWaterNeed(weight: weight, gender: gender)
        }
    }
}
