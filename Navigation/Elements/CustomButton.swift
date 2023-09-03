import UIKit

class CustomButton: UIButton {
    
    var onAction: (()->())?
    
    init(title: String, titleColor: UIColor) {
        super.init(frame: .zero)
        
        commonInit(title, titleColor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit(_ title: String, _ titleColor: UIColor) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.setBackgroundImage(UIImage(named: "blue_pixel"), for: .normal)
        self.setBackgroundImage(UIImage(named: "blue_pixel2"), for: .selected)
        self.setBackgroundImage(UIImage(named: "blue_pixel2"), for: .highlighted)
        self.setBackgroundImage(UIImage(named: "blue_pixel2"), for: .disabled)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.addTarget(self, action: #selector(buttonTapped(sender: )), for: .touchUpInside)
    }
    
    @objc func buttonTapped(sender: UIButton) {
        self.onAction?()
    }
}
