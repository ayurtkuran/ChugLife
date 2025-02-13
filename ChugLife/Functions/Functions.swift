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

    let notifications: [(hour: Int, title: String, message: String)] = [
      (9,  "Morning Drink",       "Rise and shine—time for a refreshing drink!"),
      (11, "Late Morning Slurp",  "Thirsty yet? Grab a quick drink!"),
      (13, "Midday Gulp",         "Keep going strong—take a moment to drink up!"),
      (15, "Afternoon Splash",    "Stay on track—treat yourself to a drink!"),
      (17, "Evening Sip",         "Don’t slow down—fill up your cup!"),
      (19, "Dinner Drink",        "Pair your meal with a splash of water!"),
      (21, "Night Time Nudge",     "Just one more drink before winding down!"),
      (23, "Bedtime Drip",        "A final sip for a comfy night’s rest!")
    ]

    let notificationCenter = UNUserNotificationCenter.current()
      notificationCenter.removeAllPendingNotificationRequests()

  for item in notifications {
       let hour = item.hour
       let title = item.title
       let message = item.message

       // 1) Bildirim içeriğini oluştur
       let content = UNMutableNotificationContent()
       content.title = title
       content.body = message
       content.sound = .default

       // 2) Hangi saatte tetikleneceğini ayarla
       var dateComponents = DateComponents()
       dateComponents.hour = hour
       dateComponents.minute = 0

       // 3) Her gün aynı saatte bildirim gelsin -> repeats: true
       let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

       // 4) Her bildirime kendine özgü bir identifier ver
       let identifier = "notification-\(hour)"

       // 5) UNNotificationRequest oluştur
       let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

       // 6) NotificationCenter'a ekle
       notificationCenter.add(request) { error in
           if let error = error {
               print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
           } else {
               print("Scheduled notification for \(hour):00 — \(title) | \(message)")
           }
       }
   }
}
