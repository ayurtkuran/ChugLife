import SwiftUI
import Combine
import SwiftUIGlass

struct WelcomeScreen: View {
    @State private var Name: String = ""
    @State private var Surname: String = ""
    @State private var Age: String = ""
    @State private var Weight: String = ""
    @State private var Gender: String = "Male"
    @State private var IsAppScreenActive: Bool = false
    @State private var ShowError: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy? = nil

    var areFieldsFilled: Bool {
        !Name.isEmpty && !Surname.isEmpty && !Age.isEmpty && !Weight.isEmpty
    }

    var body: some View {
        ZStack {
            GlassBackground()
                .edgesIgnoringSafeArea(.all)

            if IsAppScreenActive {
                AppScreen(name: Name, surname: Surname, age: Age, weight: Weight, gender: Gender)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: IsAppScreenActive)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("ChugLife")
                                .font(.system(size: 50, weight: .black, design: .rounded))
                                .foregroundColor(Color.textField.opacity(0.8))
                                .padding(.bottom, 40)
                                .id("Title")

                            CustomTextField(placeholder: "Name", text: $Name, width: 300, height: 40)
                                .padding(.bottom, 10)
                                .id("NameField")

                            CustomTextField(placeholder: "Surname", text: $Surname, width: 300, height: 40)
                                .padding(.bottom, 10)
                                .id("SurnameField")

                            CustomTextField(placeholder: "Age", text: $Age, width: 300, height: 40)
                                .padding(.bottom, 10)
                                .keyboardType(.decimalPad)
                                .id("AgeField")

                            CustomTextField(placeholder: "Weight as Kg", text: $Weight, width: 300, height: 40)
                                .padding(.bottom, 20)
                                .keyboardType(.decimalPad)
                                .id("WeightField")

                            CustomPicker(selectedOption: $Gender, options: ["Male", "Female"])
                                .padding(.bottom, 20)
                                .id("GenderPicker")

                            CustomButton(
                                title: "Continue",
                                width: 300,
                                height: 40,
                                action: {
                                    if areFieldsFilled {
                                        saveUserData(name: Name, surname: Surname, age: Age, weight: Weight, gender: Gender)
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            IsAppScreenActive = true
                                        }
                                    } else {
                                        ShowError = true
                                    }
                                }
                            )
                            .alert("Error", isPresented: $ShowError) {
                                Button("OK", role: .cancel) { ShowError = false }
                            } message: {
                                Text("Please fill in all fields before continuing.")
                            }
                        }
                        .padding(EdgeInsets(top: 100, leading: 20, bottom: 30, trailing: 20))
                        .onChange(of: Name) { _, _ in
                            scrollToFocusedField(proxy: proxy)
                        }
                        .onChange(of: Surname) { _, _ in
                            scrollToFocusedField(proxy: proxy)
                        }
                        .onChange(of: Age) { _, _ in
                            scrollToFocusedField(proxy: proxy)
                        }
                        .onChange(of: Weight) { _, _ in
                            scrollToFocusedField(proxy: proxy)
                        }
                    }
                    .onAppear {
                        scrollViewProxy = proxy
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    let userData = loadUserData()
                    Name = userData.name
                    Surname = userData.surname
                    Age = userData.age
                    Weight = userData.weight
                    Gender = userData.gender
                    if areFieldsFilled {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            IsAppScreenActive = true
                        }
                    }
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func scrollToFocusedField(proxy: ScrollViewProxy) {
        if !Name.isEmpty {
            proxy.scrollTo("NameField", anchor: .center)
        } else if !Surname.isEmpty {
            proxy.scrollTo("SurnameField", anchor: .center)
        } else if !Age.isEmpty {
            proxy.scrollTo("AgeField", anchor: .center)
        } else if !Weight.isEmpty {
            proxy.scrollTo("WeightField", anchor: .center)
        }
    }
}
