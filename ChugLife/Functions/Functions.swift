import SwiftUI
import UserNotifications
// MARK: - UserDefaults Functions

func saveUserData(name: String, surname: String, birthDate: Date, weight: String, gender: String) {
    UserDefaults.standard.set(name, forKey: "Name")
    UserDefaults.standard.set(surname, forKey: "Surname")
    UserDefaults.standard.set(birthDate, forKey: "BirthDate")
    UserDefaults.standard.set(weight, forKey: "Weight")
    UserDefaults.standard.set(gender, forKey: "Gender")
}

func loadUserData() -> (name: String, surname: String, birthDate: Date, weight: String, gender: String) {
    let name = UserDefaults.standard.string(forKey: "Name") ?? ""
    let surname = UserDefaults.standard.string(forKey: "Surname") ?? ""
    let birthDate = UserDefaults.standard.object(forKey: "BirthDate") as? Date ?? Date()
    let weight = UserDefaults.standard.string(forKey: "Weight") ?? ""
    let gender = UserDefaults.standard.string(forKey: "Gender") ?? "Male"
    return (name, surname, birthDate, weight, gender)
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
    UserDefaults.standard.set(nil, forKey: "BirthDate")
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

//MARK: - Notifications

func checkForPermission() {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { settings in
        switch settings.authorizationStatus {
        case .authorized:
            dispatchNotification()
        case .denied:
            return
        case .notDetermined:
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                if didAllow {
                    dispatchNotification()
                }
            }
         default:
            return
        }
    }
}

func dispatchNotification() {

    let hours = [9, 11, 13, 15, 17,19,21]

    let title = "Time to drink"
    let body = "Let's grab some water!"

    let notificationCenter = UNUserNotificationCenter.current()
     notificationCenter.removeAllPendingNotificationRequests()

    for hour in hours {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let identifier = "notification-\(hour)"

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        notificationCenter.add(request) { error in
            if let error = error {
                print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("\(hour).00 bildirimi başarıyla eklendi.")
            }
        }
    }
}
