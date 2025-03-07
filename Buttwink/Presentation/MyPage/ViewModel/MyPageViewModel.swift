//
//  MyPageViewModel.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/27/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let classListSeeAllTapped: Observable<Void>
        let bookmarkedSeeAllTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let sections: Driver<[MyPageSectionModel]>
        let selectedClass: Driver<MyPageModel>
        let navigateToAllClasses: Driver<Void>
        let navigateToAllBookmarked: Driver<Void>
    }
    
    /// 추후 Input 로직으로 수정 예정
    let classListSeeAllTappedRelay = PublishRelay<Void>()
    let bookmarkedSeeAllTappedRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let sections = input.viewDidLoad
            .map { [weak self] _ -> [MyPageSectionModel] in
                guard let self else { return [] }
                return self.createSections()
            }
            .asDriver(onErrorJustReturn: [])
        
        let selectedClass = input.itemSelected
            .withLatestFrom(sections.asObservable()) { indexPath, sections -> MyPageModel? in
                guard indexPath.section < 2 else { return nil }
                if let model = sections[indexPath.section].items[indexPath.row] as? MyPageModel {
                    return model
                }
                return nil
            }
            .compactMap { $0 }
            .asDriver(onErrorDriveWith: .empty())
        
        let navigateToAllClasses = input.classListSeeAllTapped
            .asDriver(onErrorDriveWith: .empty())
        
        let navigateToAllBookmarked = input.bookmarkedSeeAllTapped
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(
            sections: sections,
            selectedClass: selectedClass,
            navigateToAllClasses: navigateToAllClasses,
            navigateToAllBookmarked: navigateToAllBookmarked
        )
    }
    
    
}

private extension MyPageViewModel {
    func createSections() -> [MyPageSectionModel] {
        let classListSection = MyPageSectionModel.classListSection(
            title: "수업 목록",
            items: MyPageModel.createSample()
        )
        
        let bookmarkedClassSection = MyPageSectionModel.bookmarkedClassSection(
            title: "북마크한 수업",
            items: MyPageModel.createBookmarkedSample()
        )
        
        let infoItems = ["공지사항", "약관 및 정책", "로그아웃", "회원탈퇴"]
        let infoSection = MyPageSectionModel.infoSection(
            title: "설정",
            items: infoItems
        )
        
        return [classListSection, bookmarkedClassSection, infoSection]
    }
}
