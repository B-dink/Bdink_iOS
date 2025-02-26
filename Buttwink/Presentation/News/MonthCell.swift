//
//  MonthCell.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/26/25.
//

import UIKit

import SnapKit

/// 월 셀에서 날짜 선택 이벤트를 NewsViewController에 전달하기 위한 프로토콜
protocol MonthCellDelegate: AnyObject {
    func monthCell(_ cell: MonthCell, didSelectDate date: Date)
}

/// 월 날짜 표시하는 셀
/// - Parameters:
///   - 월 날짜 표시 셀
/// - Author: seungchan
final class MonthCell: UICollectionViewCell {
    private let calendar = Calendar.current
    private var date: Date?
    private var selectedDate: Date?
    weak var delegate: MonthCellDelegate?
    
    private lazy var weekdayStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
        weekdays.forEach { day in
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 12, weight: .medium)
            if day == "일" {
                label.textColor = .systemRed
            } else if day == "토" {
                label.textColor = .systemBlue
            }
            stackView.addArrangedSubview(label)
        }
        return stackView
    }()
    
    private lazy var daysCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.isScrollEnabled = false
        cv.register(DayCell.self, forCellWithReuseIdentifier: "DayCell")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(self.weekdayStackView)
        self.weekdayStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        self.contentView.addSubview(self.daysCollectionView)
        self.daysCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekdayStackView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    /// 특정 월로 셀 구성
    public func configure(with date: Date) {
        self.date = date
        daysCollectionView.reloadData()
    }
    
    /// 월에 표시할 날짜 배열 생성
    /// 각 월의 시작 전 빈 셀과 월 종료 후 빈 셀을 포함하여 항상 42일 반환
    private func getDays() -> [Date?] {
        guard let date else { return [] }
        var days: [Date?] = []
        
        /// 해당 월의 전체 날짜 및 첫 날 구하는 로직
        guard let range = self.calendar.range(of: .day, in: .month, for: date),
              let firstDayOfMonth = self.calendar.date(from: self.calendar.dateComponents([.year, .month], from: date)) else {
            return days
        }
        
        /// 첫 날이 무슨 요일인지 확인
        let firstWeekday = self.calendar.component(.weekday, from: firstDayOfMonth)
        let offsetDays = firstWeekday - self.calendar.firstWeekday
        
        if offsetDays > 0 {
            for _ in 0..<offsetDays {
                days.append(nil)
            }
        }
        
        for day in 1...range.count {
            if let date = self.calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        let remainingDays = 42 - days.count
        if remainingDays > 0 {
            for _ in 0..<remainingDays {
                days.append(nil)
            }
        }
        
        return days
    }
}

extension MonthCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let days = getDays()
        let date = days[indexPath.item]
        
        if let date {
            let isSelected = selectedDate.map { calendar.isDate($0, equalTo: date, toGranularity: .day) } ?? false
            cell.configure(with: date, isSelected: isSelected)
        } else {
            cell.configureEmpty()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = self.getDays()
        guard let date = days[indexPath.item] else { return }
        self.selectedDate = date
        self.delegate?.monthCell(self, didSelectDate: date)
        collectionView.reloadData()
    }
}

extension MonthCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: width)
    }
}
