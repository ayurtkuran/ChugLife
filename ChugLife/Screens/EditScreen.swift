import SwiftUI
import SwiftUIGlass

struct EditScreen: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var birthDate: Date = Date()
    @State private var weight: String = ""
    @State private var gender: String = "Male"
    @State private var showError: Bool = false
    @State private var closeScreen: Bool = false
    @State private var showSavedAlert: Bool = false

    var areFieldsFilled: Bool {
        !name.isEmpty && !surname.isEmpty && !weight.isEmpty
    }

    var body: some View {
        ZStack {
            if closeScreen {
                AppScreen(name: name, surname: surname, birthDate: birthDate, weight: weight, gender: gender)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: closeScreen)
            } else {
                ZStack {
                    GlassBackground()
                        .edgesIgnoringSafeArea(.all)

                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Edit Information")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(Color.textField.opacity(0.8))
                                .padding(.top, 40)

                            // Name Field
                            CustomTextField(placeholder: "Name", text: $name, width: 300, height: 40)
                                .disabled(true)

                            // Surname Field
                            CustomTextField(placeholder: "Surname", text: $surname, width: 300, height: 40)
                                .disabled(true)

                            // Birth Date Field
                            HStack {
                                Text("Birth Date")
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.textField.opacity(0.8))
                                    .frame(width: 100, alignment: .leading)

                                Spacer()

                                Text(birthDate, formatter: dateFormatter)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.textField)
                            }
                            .padding()
                            .frame(width: 300, height: 40)
                            .background(Color.glassBackground)
                            .cornerRadius(7)

                            // Weight Field
                          CustomTextField(placeholder: "Weight (Kg)", text: $weight, width: 300, height: 40,keyboardType: .numberPad)


                            // Save Button
                            CustomButton(title: "Save", width: 300, height: 40) {
                                if areFieldsFilled {
                                    saveUserData(name: name, surname: surname, birthDate: birthDate, weight: weight, gender: gender)
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

                            // Cancel Button
                            CustomButton(title: "Cancel", width: 300, height: 40) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    closeScreen.toggle()
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.5), value: closeScreen)
                .onAppear {
                    let userData = loadUserData()
                    name = userData.name
                    surname = userData.surname
                    birthDate = userData.birthDate
                    weight = userData.weight
                    gender = userData.gender
                }
            }
        }
    }

    // Tarih formatı için yardımcı
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}


