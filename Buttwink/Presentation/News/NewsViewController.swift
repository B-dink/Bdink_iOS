//
//  NewsViewController.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/26/25.
//

import UIKit

import SnapKit

/// 가로 스크롤 캘린더 +
/// - Parameters:
///   - 스크롤을 통해 월 간 이동 가능
///   - 상단에는 현재 표시 중인 월/년도 표시,, 날짜 선택 가능
/// - Author: seungchan
final class NewsViewController: UIViewController {
    /// 캘린더 객체
    private let calendar = Calendar.current
    /// 표시할 월 단위 날짜 배열 (각 월의 첫날을 저장)
    private var months: [Date] = []
    /// 캘린더에 나타낼 총 월 수
    private let monthsToLoad = 24
    /// 사용자가 선택한 날짜를 저장
    private var selectedDate: Date?
    /// 현재 시스템 날짜 (매번 생성 시 코스트가 많이 들어서 하나로 사용)
    private let currentDate = Date()
    /// 표시할 월 배열의 중간 인덱스를 계산 (현재 월을 중심으로 과거/미래 월을 보여주기 위함)
    private var centerIndex: Int {
        return monthsToLoad / 2
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.register(MonthCell.self, forCellWithReuseIdentifier: "MonthCell")
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    /// 캘린더에 표시할 월 데이터 생성
    private func generateMonths() {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        components.day = 1
        
        guard let baseDate = calendar.date(from: components) else { return }
        
        self.months.removeAll()
        
        for i in 1...self.centerIndex {
            if let date = self.calendar.date(byAdding: .month, value: -i, to: baseDate) {
                self.months.append(date)
            }
        }
        
        self.months.append(baseDate)
        
        for i in 1...self.centerIndex {
            if let date = self.calendar.date(byAdding: .month, value: i, to: baseDate) {
                self.months.append(date)
            }
        }
        
        self.months.sort { $0 < $1 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.generateMonths()
        self.scrollToCurrentMonth()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(self.monthLabel)
        self.monthLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    private func scrollToCurrentMonth() {
        DispatchQueue.main.async {
            self.scrollToCurrentMonth(animated: false)
        }
    }
    
    /// 현재 월로 스크롤
    private func scrollToCurrentMonth(animated: Bool) {
        /// 현재 날짜와 동일한 월을 가진 날짜의 인덱스 찾기
        guard let currentMonthIndex = months.firstIndex(where: { date in
            return self.calendar.isDate(date, equalTo: self.currentDate, toGranularity: .month)
        }) else { return }
        
        /// 해당 인덱스로 스크롤
        let indexPath = IndexPath(item: currentMonthIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        self.updateMonthLabel(for: self.months[currentMonthIndex])
    }
    
    private func updateMonthLabel(for date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        self.monthLabel.text = formatter.string(from: date)
    }
}

extension NewsViewController: UICollectionViewDataSource {
    /// 총 월 수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthCell
        let month = self.months[indexPath.item]
        cell.configure(with: month)
        cell.delegate = self
        return cell
    }
}

extension NewsViewController: UICollectionViewDelegateFlowLayout {
    /// 각 월 셀 크기 설정 - 전체 화면 너비로 설정하여 한 번에 한 월만 보이도록
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    /// 스크롤 감속이 끝났을 때 현재 월 업데이트
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentMonth(scrollView)
    }
    
    /// 스크롤 드래그가 끝났을 때 현재 월 업데이트 (감속이 없는 경우)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateCurrentMonth(scrollView)
        }
    }
    
    /// 현재 표시 중인 월을 업데이트하는 메소드
    private func updateCurrentMonth(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let currentPage = Int(round(scrollView.contentOffset.x / pageWidth))
        guard currentPage >= 0 && currentPage < self.months.count else { return }
        let month = self.months[currentPage]
        self.updateMonthLabel(for: month)
    }
}

extension NewsViewController: MonthCellDelegate {
    /// 사용자가 선택한 날짜
    func monthCell(_ cell: MonthCell, didSelectDate date: Date) {
        self.selectedDate = date
    }
}
