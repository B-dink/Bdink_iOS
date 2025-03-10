//
//  TextFieldBuilder.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/10/25.
//

import UIKit

import SnapKit

enum TextFieldState {
    case normal
    case error
    case warning
    case success
    case custom(UIColor)
    
    var color: UIColor {
        switch self {
        case .normal:
            return UIColor.lightGray
        case .error:
            return UIColor.red
        case .warning:
            return UIColor.orange
        case .success:
            return UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        case .custom(let color):
            return color
        }
    }
}

final class TextFieldBuilder: UITextField {
    private var stateMessageLabel: UILabel?
    private var currentState: TextFieldState = .normal
    private var leftPadding: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTextField()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupTextField()
    }
    
    private func setupTextField() {
        self.backgroundColor = .buttwink_gray900
        self.font = UIFont.systemFont(ofSize: 14)
        self.textColor = .white
        
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
        self.updateLeftPadding(20)
        
        self.snp.makeConstraints {
            $0.height.equalTo(54)
        }
    }

    @discardableResult
    func placeholder(_ placeholder: String) -> TextFieldBuilder {
        self.placeholder = placeholder
        setPlaceholder(color: .white)
        return self
    }
    
    @discardableResult
    func leftPadding(_ padding: CGFloat) -> TextFieldBuilder {
        self.leftPadding = padding
        updateLeftPadding(padding)
        return self
    }
    
    private func updateLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }

    
    @discardableResult
    func setStateMessageLabel(_ label: UILabel) -> TextFieldBuilder {
        self.stateMessageLabel = label
        return self
    }
}

// MARK: - UITextField 확장
extension UITextField {
    static func builder() -> TextFieldBuilder {
        return TextFieldBuilder(frame: .zero)
    }
    
    func setPlaceholder(color: UIColor) {
        guard let string = self.placeholder else {
            return
        }
        attributedPlaceholder = NSAttributedString(string: string, attributes: [.foregroundColor: color])
    }
}
