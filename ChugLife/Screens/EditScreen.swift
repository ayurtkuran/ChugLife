import SwiftUI
import SwiftUIGlass

struct EditScreen: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var gender: String = "Male"
    @State private var showError: Bool = false
    @State private var closeScreen: Bool = false
    @State private var showSavedAlert: Bool = false

    var areFieldsFilled: Bool {
        !name.isEmpty && !surname.isEmpty && !age.isEmpty && !weight.isEmpty
    }

    var body: some View {
        ZStack {
            if closeScreen {
                AppScreen(name: name, surname: surname, age: age, weight: weight, gender: gender)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: closeScreen)
            } else {
                ZStack {
                    GlassBackground()
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Text("Edit Information")
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(Color.textField.opacity(0.8))
                            .padding(.top, 40)

                        CustomTextField(placeholder: "Name", text: $name, width: 300, height: 40)
                        CustomTextField(placeholder: "Surname", text: $surname, width: 300, height: 40)
                        CustomTextField(placeholder: "Age", text: $age, width: 300, height: 40)
                            .keyboardType(.decimalPad)
                        CustomTextField(placeholder: "Weight (Kg)", text: $weight, width: 300, height: 40)
                            .keyboardType(.decimalPad)

                        CustomButton(title: "Save", width: 300, height: 40) {
                            if areFieldsFilled {
                                saveUserData(name: name, surname: surname, age: age, weight: weight, gender: "Male")
                                showSavedAlert = true
                            } else {
                                showError = true
                            }
                        }
                        .alert("Saved", isPresented: $showSavedAlert) {
                            Button("OK") {
                                showSavedAlert = false
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    closeScreen.toggle()
                                }
                            }
                        }
                        .alert("Error", isPresented: $showError) {
                            Button("OK", role: .cancel) {
                                showError = false
                            }
                        } message: {
                            Text("Please fill in all fields before saving.")
                        }

                        CustomButton(title: "Cancel", width: 300, height: 40) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                closeScreen.toggle()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: closeScreen)
                .onAppear {
                    let userData = loadUserData()
                    name = userData.name
                    surname = userData.surname
                    age = userData.age
                    weight = userData.weight
                }
            }
        }
    }
}
