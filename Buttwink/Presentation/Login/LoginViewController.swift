//
//  LoginViewController.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/10/25.
//

import UIKit

import SnapKit

final class LoginViewController: UIViewController, ViewControllable {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.Img.bdink
        return imageView
    }()
    
    private let emailTextField = UITextField.builder()
        .placeholder("이메일 주소")
    
    private let passwordTextField = UITextField.builder()
        .placeholder("비밀번호")
    
    private let nextButton = ButtwinkButton(frame: .zero)
        .title("로그인")
        .backgroundColor(.buttwink_gray900)
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()
    
    private let findIdButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디 찾기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private let findPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setStyle()
        self.setupUI()
        self.setupConstraints()
    }
    
    private func setupUI() {
        self.stackView.addArrangedSubview(self.findIdButton)
        self.stackView.addArrangedSubview(self.findPasswordButton)
        self.stackView.addArrangedSubview(self.signUpButton)
        
        self.view.addSubview(self.logoImageView)
        self.view.addSubview(self.emailTextField)
        self.view.addSubview(self.passwordTextField)
        self.view.addSubview(self.nextButton)
        self.view.addSubview(self.stackView)
    }
    
    private func setupConstraints() {
        self.logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.7)
            $0.leading.equalToSuperview().inset(36)
            $0.height.equalTo(72)
            $0.width.equalTo(140)
        }
        
        self.emailTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(31)
            $0.top.equalTo(self.logoImageView.snp.bottom).offset(40)
        }
        
        self.passwordTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(31)
            $0.top.equalTo(self.emailTextField.snp.bottom).offset(8)
        }
        
        self.nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(31)
            $0.top.equalTo(self.passwordTextField.snp.bottom).offset(18)
        }
        
        self.stackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(31)
            $0.top.equalTo(self.nextButton.snp.bottom).offset(18)
            $0.height.equalTo(44)
        }
    }
}

