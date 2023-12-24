import UIKit
import UserNotifications

class LocalNotificationsService {
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            completion(granted)
        }
    }
    
    func registerForLatestUpdatesIfPossible() {
        self.scheduleDailyUpdateNotification()
    }

    private func scheduleDailyUpdateNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Посмотрите последние обновления"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 19
        dateComponents.minute = 25

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyUpdate", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при планировании уведомления: \(error)")
            }
        }
    }
}
