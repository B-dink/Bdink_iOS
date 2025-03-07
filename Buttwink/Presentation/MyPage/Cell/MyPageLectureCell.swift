//
//  MyPageLectureCell.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/4/25.
//

import UIKit

import RxSwift

final class MyPageLectureCell: UICollectionViewCell {
    static let identifier = "MyPageLectureCell"
    private let disposeBag = DisposeBag()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .green
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        return label     }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .systemGray5
        progressView.progressTintColor = .systemBlue
        return progressView
    }()
    
    private let instructorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.contentView.backgroundColor = .black
        
        self.contentView.addSubview(self.containerView)
        self.containerView.addSubview(self.thumbnailImageView)
        self.containerView.addSubview(self.titleLabel)
        self.containerView.addSubview(self.progressView)
        self.containerView.addSubview(self.instructorLabel)
        
        self.containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
        
        self.thumbnailImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(115)
        }

        self.progressView.snp.makeConstraints {
            $0.top.equalTo(self.thumbnailImageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.thumbnailImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
        
        self.instructorLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview().inset(12)
        }
    }
    
    // MARK: - Configure
    func configure(with model: MyPageModel) {
        titleLabel.text = model.title
        progressView.progress = Float(model.progress ?? 0.0)
        progressView.isHidden = model.progress == nil
        instructorLabel.text = model.instructor
    }
}
