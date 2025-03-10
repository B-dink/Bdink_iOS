//
//  ButtwinkButton.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/10/25.
//

import UIKit

import SnapKit

final class ButtwinkButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.lightGray, for: .highlighted)
        self.layer.borderColor = UIColor.white.cgColor
        
        self.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }

    func setTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                alpha = 1.0
                backgroundColor = .black
            } else {
                alpha = 0.5
                backgroundColor = .darkGray
            }
        }
    }
    
    func setHighlighted(_ highlighted: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.alpha = highlighted ? 0.8 : 1.0
            self.transform = highlighted ? CGAffineTransform(scaleX: 0.98, y: 0.98) : .identity
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setHighlighted(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setHighlighted(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setHighlighted(false)
    }
    
    @discardableResult
    func title(_ title: String) -> ButtwinkButton {
        setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func borderColor(_ color: UIColor) -> ButtwinkButton {
        return self
    }
    
    @discardableResult
    func backgroundColor(_ color: UIColor) -> ButtwinkButton {
        backgroundColor = color
        return self
    }
}
