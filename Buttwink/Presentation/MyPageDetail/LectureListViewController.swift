//
//  LectureListViewController.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/7/25.
//

import UIKit

import SnapKit

final class LectureListViewController: UIViewController {
    
    private let tabScrollView = UIScrollView()
    private let tabContentView = UIView()
    private let inProgressTab = UIButton()
    private let completedTab = UIButton()
    private let tabIndicator = UIView()
    
    private let contentScrollView = UIScrollView()
    private let inProgressView = UIView()
    private let completedView = UIView()
    
    private var currentTabIndex: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.setupUI()
        self.configureTabs()
        self.setupGestures()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        
        self.tabScrollView.showsHorizontalScrollIndicator = false
        self.tabScrollView.isPagingEnabled = true
        self.view.addSubview(self.tabScrollView)
        
        self.tabScrollView.addSubview(self.tabContentView)
        
        self.inProgressTab.setTitle("학습중", for: .normal)
        self.inProgressTab.setTitleColor(.white, for: .normal)
        self.inProgressTab.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        self.inProgressTab.tag = 0
        
        self.completedTab.setTitle("완강", for: .normal)
        self.completedTab.setTitleColor(.white, for: .normal)
        self.completedTab.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        self.completedTab.tag = 1
        
        self.tabContentView.addSubview(self.inProgressTab)
        self.tabContentView.addSubview(self.completedTab)
        
        self.tabIndicator.backgroundColor = .white
        self.tabContentView.addSubview(self.tabIndicator)
        
        self.contentScrollView.isPagingEnabled = true
        self.contentScrollView.showsHorizontalScrollIndicator = false
        self.contentScrollView.delegate = self
        self.view.addSubview(self.contentScrollView)
        
        self.inProgressView.backgroundColor = .black
        self.completedView.backgroundColor = .black
        self.contentScrollView.addSubview(self.inProgressView)
        self.contentScrollView.addSubview(self.completedView)
        
        self.inProgressView.backgroundColor = .yellow
        self.completedView.backgroundColor = .green
        
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        self.tabScrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(100)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        self.tabContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(self.tabScrollView)
            $0.width.equalToSuperview()
        }
        
        self.inProgressTab.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.width.equalTo(self.view.snp.width).dividedBy(2)
        }
        
        self.completedTab.snp.makeConstraints {
            $0.trailing.verticalEdges.equalToSuperview()
            $0.width.equalTo(self.view.snp.width).dividedBy(2)
        }
        
        self.tabIndicator.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(2)
            $0.width.equalTo(self.view.snp.width).dividedBy(2)
        }
        
        self.contentScrollView.snp.makeConstraints {
            $0.top.equalTo(tabScrollView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        self.inProgressView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview()
            $0.width.equalTo(view.snp.width)
            $0.height.equalTo(contentScrollView)
        }
        
        self.completedView.snp.makeConstraints {
            $0.verticalEdges.trailing.equalToSuperview()
            $0.leading.equalTo(self.inProgressView.snp.trailing)
            $0.width.equalTo(view.snp.width)
        }
    }
    
    private func configureTabs() {
        self.inProgressTab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.completedTab.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.inProgressTab.setTitleColor(.white, for: .normal)
        self.completedTab.setTitleColor(.gray, for: .normal)
    }
   
    
    private func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        self.switchTab(to: sender.tag)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left && self.currentTabIndex == 0 {
            self.switchTab(to: 1)
        } else if gesture.direction == .right && self.currentTabIndex == 1 {
            self.switchTab(to: 0)
        }
    }
    
    private func switchTab(to index: Int) {
        self.currentTabIndex = index
        
        UIView.animate(withDuration: 0.3) {
            self.tabIndicator.snp.remakeConstraints {
                $0.bottom.equalToSuperview()
                $0.height.equalTo(2)
                $0.width.equalTo(self.view.snp.width).dividedBy(2)
                $0.leading.equalToSuperview().offset(index == 0 ? 0 : self.view.frame.width / 2)
            }
            self.view.layoutIfNeeded()
        }
        
        self.contentScrollView.setContentOffset(CGPoint(x: index * Int(view.frame.width), y: 0), animated: true)
        
        if index == 0 {
            self.inProgressTab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.completedTab.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.inProgressTab.setTitleColor(.white, for: .normal)
            self.completedTab.setTitleColor(.gray, for: .normal)
        } else {
            self.inProgressTab.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            self.completedTab.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.inProgressTab.setTitleColor(.gray, for: .normal)
            self.completedTab.setTitleColor(.white, for: .normal)
        }
    }
}

extension LectureListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.contentScrollView {
            let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
            self.switchTab(to: pageIndex)
        }
    }
}
