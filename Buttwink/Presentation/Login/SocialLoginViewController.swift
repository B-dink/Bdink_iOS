//
//  SocialLoginViewController.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/7/25.
//

import UIKit

import DesignSystem

import SnapKit

final class SocialLoginViewController: UIViewController, ViewControllable {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Img.bdink
        return imageView
    }()
    
    private let kakaoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.Img.kakaoLogin, for: .normal)
        return button
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setImage(UIImage.Img.appleLogin, for: .normal)
        return button
    }()
    
    private let emailLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일로 로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let emailSignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일로 회원가입", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        self.createAttributedPrivacyLabel(label: label)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupConstraints()
        self.setStyle()
    }
    
    private func setupUI() {
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.kakaoButton)
        self.view.addSubview(self.appleButton)
        self.view.addSubview(self.emailLoginButton)
        self.view.addSubview(self.emailSignupButton)
        self.view.addSubview(self.privacyLabel)
    }
    
    private func setupConstraints() {
        self.logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.7)
            $0.leading.equalToSuperview().inset(36)
            $0.height.equalTo(72)
            $0.width.equalTo(140)
        }
        
        self.kakaoButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(315)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.3)
        }
        
        self.appleButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(315)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.kakaoButton.snp.bottom).offset(10)
        }
        
        self.emailLoginButton.snp.makeConstraints {
            $0.leading.equalTo(self.appleButton.snp.leading).inset(28)
            $0.top.equalTo(self.appleButton.snp.bottom).offset(21)
        }
        
        self.emailSignupButton.snp.makeConstraints {
            $0.trailing.equalTo(self.appleButton.snp.trailing).inset(28)
            $0.top.equalTo(self.appleButton.snp.bottom).offset(21)
        }
        
        self.privacyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.emailLoginButton.snp.bottom).offset(23)
        }
    }
    
    func createAttributedPrivacyLabel(label: UILabel) {
        let fullText = "가입하면 버딩크의 이용약관, 개인정보 처리방침에 동의하게 됩니다."
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let privacyPolicyRange = (fullText as NSString).range(of: "이용약관")
        let personalInfoRange = (fullText as NSString).range(of: "개인정보 처리방침")
        
        let linkColor = UIColor(red: 168/255, green: 255/255, blue: 95/255, alpha: 1.0)
        attributedString.addAttribute(.foregroundColor, value: linkColor, range: privacyPolicyRange)
        attributedString.addAttribute(.foregroundColor, value: linkColor, range: personalInfoRange)
        
        let normalTextColor = UIColor.lightGray
        
        attributedString.addAttribute(.foregroundColor, value: normalTextColor, range: NSRange(location: 0, length: privacyPolicyRange.location))
        
        let middleRangeStart = privacyPolicyRange.location + privacyPolicyRange.length
        let middleRangeLength = personalInfoRange.location - middleRangeStart
        attributedString.addAttribute(.foregroundColor, value: normalTextColor, range: NSRange(location: middleRangeStart, length: middleRangeLength))
        
        let endRangeStart = personalInfoRange.location + personalInfoRange.length
        let endRangeLength = fullText.count - endRangeStart
        attributedString.addAttribute(.foregroundColor, value: normalTextColor, range: NSRange(location: endRangeStart, length: endRangeLength))
        
        label.attributedText = attributedString
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
    }
}
