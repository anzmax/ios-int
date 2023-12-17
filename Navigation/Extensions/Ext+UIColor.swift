import UIKit

extension UIColor {
    static let customWhite = UIColor.createColor(lightMode: .white, darkMode: .systemGray5)
    static let customGray = UIColor.createColor(lightMode: .systemGray2, darkMode: .white)
    static let customBlue = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
    static let customBlack = UIColor.createColor(lightMode: .black, darkMode: .white)
    
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else {
            return lightMode
        }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}
