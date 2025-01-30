import SwiftUI
// MARK: - UserDefaults Functions

func saveUserData(name: String, surname: String, age: String, weight: String, gender: String) {
    UserDefaults.standard.set(name, forKey: "Name")
    UserDefaults.standard.set(surname, forKey: "Surname")
    UserDefaults.standard.set(age, forKey: "Age")
    UserDefaults.standard.set(weight, forKey: "Weight")
    UserDefaults.standard.set(gender, forKey: "Gender")
}

func loadUserData() -> (name: String, surname: String, age: String, weight: String, gender: String) {
    let name = UserDefaults.standard.string(forKey: "Name") ?? ""
    let surname = UserDefaults.standard.string(forKey: "Surname") ?? ""
    let age = UserDefaults.standard.string(forKey: "Age") ?? ""
    let weight = UserDefaults.standard.string(forKey: "Weight") ?? ""
    let gender = UserDefaults.standard.string(forKey: "Gender") ?? "Male"
    return (name, surname, age, weight, gender)
}

func deleteUserData() {
    UserDefaults.standard.removeObject(forKey: "Name")
    UserDefaults.standard.removeObject(forKey: "Surname")
    UserDefaults.standard.removeObject(forKey: "Age")
    UserDefaults.standard.removeObject(forKey: "Weight")
    UserDefaults.standard.removeObject(forKey: "Gender")
}

// MARK: - Calculate Daily Water Need

func calculateDailyWaterNeed(weight: String, gender: String) -> Double {
    guard let weightDouble = Double(weight) else { return 0 }
    return (gender == "Male") ? (weightDouble * 35) : (weightDouble * 31)
}
