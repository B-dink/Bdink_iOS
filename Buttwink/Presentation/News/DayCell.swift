//
//  DayCell.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/26/25.
//

import UIKit

import SnapKit

/// 일 날짜 표시하는 셀
/// - Parameters:
///   - 일 날짜 표시 셀
/// - Author: seungchan

final class DayCell: UICollectionViewCell {
    private let calendar = Calendar.current
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 2
        view.isHidden = true
        return view
    }()
    
    private var isDateSelected: Bool = false {
        didSet {
            self.selectionIndicator.isHidden = !self.isDateSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.selectionIndicator)
        
        self.dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        self.selectionIndicator.snp.makeConstraints {
            $0.top.equalTo(self.dateLabel.snp.bottom).offset(2)
            $0.centerX.equalTo(self.dateLabel)
            $0.size.equalTo(4)
        }
    }
    
    /// 기본 날짜 뷰 및 선택 뷰
    public func configure(with date: Date, isSelected: Bool = false) {
        let day = calendar.component(.day, from: date)
        self.dateLabel.text = "\(day)"
        self.isDateSelected = isSelected
        
        if calendar.isDate(date, equalTo: Date(), toGranularity: .day) {
            self.dateLabel.textColor = .white
            self.dateLabel.backgroundColor = .systemBlue
            self.dateLabel.layer.cornerRadius = 16
            self.dateLabel.clipsToBounds = true
        } else {
            self.dateLabel.backgroundColor = .clear
            
            let weekday = calendar.component(.weekday, from: date)
            if weekday == 1 {
                self.dateLabel.textColor = .systemRed
            } else if weekday == 7 {
                self.dateLabel.textColor = .systemBlue
            } else {
                self.dateLabel.textColor = .label
            }
        }
    }
    
    /// 빈 셀 뷰
    public func configureEmpty() {
        self.dateLabel.text = ""
        self.dateLabel.backgroundColor = .clear
        self.isDateSelected = false
    }
}

