//
//  MyPageSectionModel.swift
//  Buttwink
//
//  Created by MEGA_Mac on 3/4/25.
//

import Foundation

import RxDataSources

enum MyPageSectionModel {
    case classListSection(title: String, items: [MyPageModel])
    case bookmarkedClassSection(title: String, items: [MyPageModel])
    case infoSection(title: String, items: [String])
}

extension MyPageSectionModel: SectionModelType {
    typealias Item = Any
    
    var items: [Item] {
        switch self {
        case .classListSection(_, let items):
            return items.map { $0 as Item }
        case .bookmarkedClassSection(_, let items):
            return items.map { $0 as Item }
        case .infoSection(_, let items):
            return items.map { $0 as Item }
        }
    }
    
    var title: String {
        switch self {
        case .classListSection(let title, _),
             .bookmarkedClassSection(let title, _),
             .infoSection(let title, _):
            return title
        }
    }
    
    init(original: MyPageSectionModel, items: [Item]) {
        switch original {
        case let .classListSection(title, _):
            self = .classListSection(title: title, items: items as! [MyPageModel])
        case let .bookmarkedClassSection(title, _):
            self = .bookmarkedClassSection(title: title, items: items as! [MyPageModel])
        case let .infoSection(title, _):
            self = .infoSection(title: title, items: items as! [String])
        }
    }
}
