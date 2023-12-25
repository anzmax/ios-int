import UIKit
import UserNotifications

final class LocalNotificationsService {

    let center = UNUserNotificationCenter.current()

    func registerForLatestUpdatesIfPossible() {
        center.requestAuthorization(options: [.sound, .badge, .alert]) { [weak self] success, error in
            if success {
                let content = UNMutableNotificationContent()
                content.title = "Посмотрите последние обновления"
                content.sound = .default

                var dateComponents = DateComponents()
                dateComponents.hour = 17
                dateComponents.minute = 26

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                self?.center.add(request) { error in
                    if let error = error {
                        print("Ошибка при планировании уведомления: \(error)")
                    }
                }

            } else if let error = error {
                print("Ошибка авторизации уведомлений: \(error.localizedDescription)")
            } else {
                print("Авторизация уведомлений не получена")
            }
        }
    }
}
