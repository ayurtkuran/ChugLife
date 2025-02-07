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

func clearWaterData(_ consumedWater: Binding<Double>) {
    consumedWater.wrappedValue = 0
    UserDefaults.standard.set(0, forKey: "ConsumedWater")
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
// MARK: - Daily Update Consumed Water
func isNewDayComparedToLastSavedDate() -> Bool {
    let calendar = Calendar.current
    let now = Date()

    // Kaydedilen son tarihi UserDefaults’tan çekiyoruz.
    // Eğer yoksa çok eski bir tarih gibi düşünebiliriz.
    let lastDate = UserDefaults.standard.object(forKey: "LastResetDate") as? Date
                   ?? Date(timeIntervalSince1970: 0)

    // 'now' ve 'lastDate'in sadece YIL, AY ve GÜN bileşenlerini alıyoruz.
    let nowComponents = calendar.dateComponents([.year, .month, .day], from: now)
    let lastDateComponents = calendar.dateComponents([.year, .month, .day], from: lastDate)

    // Gün, ay veya yıl farklıysa "yeni gün" anlamına gelir
    return (nowComponents.day != lastDateComponents.day ||
            nowComponents.month != lastDateComponents.month ||
            nowComponents.year != lastDateComponents.year)
}
