//
//  MyPageModel.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/4/25.
//

import Foundation

struct MyPageModel {
    let id: String
    let title: String
    let progress: Double?
    let instructor: String
    let isBookmarked: Bool
    
    /// 수업 목록 init
    init(
        id: String,
        title: String,
        progress: Double,
        instructor: String,
        isBookmarked: Bool
    ) {
        self.id = id
        self.title = title
        self.progress = progress
        self.instructor = instructor
        self.isBookmarked = isBookmarked
    }
    
    /// 북마크 init
    init(
        id: String,
        title: String,
        instructor: String,
        isBookmarked: Bool
    ) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.isBookmarked = isBookmarked
        self.progress = nil
    }
    
    
    static func createSample() -> [MyPageModel] {
        return [
            MyPageModel(
                id: "1",
                title: "진행률(ex 90%)",
                progress: 0.1,
                instructor: "강의자 이름",
                isBookmarked: false
            ),
            MyPageModel(
                id: "2",
                title: "진행률(ex 90%)",
                progress: 0.3,
                instructor: "수강중인 강의제목",
                isBookmarked: false
            ),
            MyPageModel(
                id: "3",
                title: "진행률(ex 90%)",
                progress: 0.4,
                instructor: "수강중인 강의제목",
                isBookmarked: false
            ),
            MyPageModel(
                id: "4",
                title: "진행률(ex 90%)",
                progress: 0.9,
                instructor: "수강중인 강의제목",
                isBookmarked: false
            ),
        ]
    }
    
    static func createBookmarkedSample() -> [MyPageModel] {
        return [
            MyPageModel(
                id: "10",
                title: "강의명 2줄 /n (23차 노출)",
                instructor: "강사명",
                isBookmarked: true
            ),
            MyPageModel(
                id: "11",
                title: "강의명 2줄 /n (23차 노출)",
                instructor: "강사명",
                isBookmarked: true
            ),
            MyPageModel(
                id: "12",
                title: "강의명 2줄 /n (23차 노출)",
                instructor: "강사명",
                isBookmarked: true
            ),
            MyPageModel(
                id: "13",
                title: "강의명 2줄 /n (23차 노출)",
                instructor: "강사명",
                isBookmarked: true
            ),
        ]
    }
}
