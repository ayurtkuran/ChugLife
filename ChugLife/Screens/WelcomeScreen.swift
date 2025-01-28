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
            // Arka planı tüm ekranı kaplayacak şekilde ayarla
            GlassBackground()
                .edgesIgnoringSafeArea(.all)

            if IsAppScreenActive {
                // AppScreen'e geçiş yap
                AppScreen(name: Name, surname: Surname, age: Age, weight: Weight, gender: Gender)
                    .transition(.move(edge: .trailing)) // Sağdan kayarak gelme animasyonu
                    .animation(.easeInOut(duration: 0.5), value: IsAppScreenActive) // Animasyon süresi ve türü
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) {
                          Text("ChugLife")
                            .font(.system(size: 50, weight: .black, design: .rounded))
                            .foregroundColor(Color.textField.opacity(0.8))
                            .padding(.bottom, 40)
                            .id("Title") // ScrollView'da odaklanılabilir bir ID
                          
                          CustomTextField(placeholder: "Name", text: $Name, width: 300, height: 40)
                            .padding(.bottom, 10)
                            .id("NameField") // ScrollView'da odaklanılabilir bir ID
                          
                          CustomTextField(placeholder: "Surname", text: $Surname, width: 300, height: 40)
                            .padding(.bottom, 10)
                            .id("SurnameField") // ScrollView'da odaklanılabilir bir ID
                          
                          CustomTextField(placeholder: "Age", text: $Age, width: 300, height: 40)
                            .padding(.bottom, 10)
                            .keyboardType(.decimalPad) // "OK" butonu ekle
                            .id("AgeField") // ScrollView'da odaklanılabilir bir ID
                          
                          CustomTextField(placeholder: "Weight as Kg", text: $Weight, width: 300, height: 40)
                            .padding(.bottom, 20)
                            .keyboardType(.decimalPad)// "OK" butonu ekle
                            .id("WeightField") // ScrollView'da odaklanılabilir bir ID
                          
                          CustomPicker(selectedOption: $Gender, options: ["Male", "Female"])
                            .padding(.bottom, 20)
                            .id("GenderPicker") // ScrollView'da odaklanılabilir bir ID
                          
                          CustomButton(
                            title: "Continue",
                            width: 300,
                            height: 40,
                            action: {
                              if areFieldsFilled {
                                saveUserData(name: Name, surname: Surname, age: Age, weight: Weight, gender: Gender)
                                withAnimation(.easeInOut(duration: 1.0)) {
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
                        .padding(EdgeInsets(top: 100, leading: 20, bottom: 30, trailing: 20)) // Adjusted padding to move content lower
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
                .frame(maxWidth: .infinity, maxHeight: .infinity) // ScrollView'u tüm ekranı kaplayacak şekilde ayarla
                .edgesIgnoringSafeArea(.all) // Güvenli alanı yoksay
                .onAppear {
                    let userData = loadUserData()
                    Name = userData.name
                    Surname = userData.surname
                    Age = userData.age
                    Weight = userData.weight
                    Gender = userData.gender
                    if areFieldsFilled {
                      withAnimation(.easeInOut(duration:1.0)) {
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
  

    // Odaklanılan alana otomatik kaydırma
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
