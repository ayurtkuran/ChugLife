import SwiftUI
import Combine
import SwiftUIGlass

struct WelcomeScreen: View {
    @State private var Name: String = ""
    @State private var Surname: String = ""
    @State private var BirthDate: Date? = nil // Optional<Date> olarak başlatıldı
    @State private var Weight: String = ""
    @State private var Gender: String = "Male"
    @State private var IsAppScreenActive: Bool = false
    @State private var ShowError: Bool = false
    @State private var scrollViewProxy: ScrollViewProxy? = nil
    @State private var showDatePicker: Bool = false // DatePicker'i göstermek için

    var areFieldsFilled: Bool {
        !Name.isEmpty && !Surname.isEmpty && !Weight.isEmpty && BirthDate != nil // BirthDate'nin dolu olup olmadığını kontrol et
    }

    var body: some View {
        ZStack {
            GlassBackground()
                .edgesIgnoringSafeArea(.all)

            if IsAppScreenActive {
                AppScreen(name: Name, surname: Surname, birthDate: BirthDate!, weight: Weight, gender: Gender)
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

                            // Özelleştirilmiş tarih seçimi butonu
                            CustomDateButton(
                                placeholder: "Birth Date",
                                date: $BirthDate,
                                width: 300,
                                height: 40,
                                action: {
                                    withAnimation {
                                        showDatePicker.toggle() // DatePicker'i aç/kapat
                                    }
                                }
                            )
                            .padding(.bottom, 10)
                            .id("BirthdayField")

                            // DatePicker modal
                            if showDatePicker {
                                VStack {
                                    DatePicker(
                                        "",
                                        selection: Binding(
                                            get: { self.BirthDate ?? Date() }, // BirthDate nil ise Date() kullan
                                            set: { self.BirthDate = $0 } // Yeni tarihi atayın
                                        ),
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                                    .padding(.horizontal, 20)
                                }
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.3), value: showDatePicker)
                            }

                          CustomTextField(placeholder: "Weight as Kg", text: $Weight, width: 300, height: 40,keyboardType: .numberPad)
                                .padding(.bottom, 20)                         .id("WeightField")

                            CustomPicker(selectedOption: $Gender, options: ["Male", "Female"])
                                .padding(.bottom, 20)
                                .id("GenderPicker")

                            CustomButton(
                                title: "Continue",
                                width: 300,
                                height: 40,
                                action: {
                                    if areFieldsFilled {
                                        saveUserData(name: Name, surname: Surname, birthDate: BirthDate!, weight: Weight, gender: Gender)
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
                        .onChange(of: Weight) { _, _ in
                            scrollToFocusedField(proxy: proxy)
                        }
                    }
                    .onAppear {
                      checkForPermission()
                        scrollViewProxy = proxy
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    let userData = loadUserData()
                    Name = userData.name
                    Surname = userData.surname
                  BirthDate = userData.birthDate
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
        } else if !Weight.isEmpty {
            proxy.scrollTo("WeightField", anchor: .center)
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

