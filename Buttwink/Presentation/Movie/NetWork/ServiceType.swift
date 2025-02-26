//
//  ServiceType.swift
//  Buttwink
//
//  Created by 이지훈 on 12/22/24.
//

import Foundation
import Moya

protocol BoxOfficeServiceProtocol {
    func fetchDailyBoxOffice(date: String) async throws -> [Movie]
}

//final class BoxOfficeService: BoxOfficeServiceProtocol {
//    private let provider: MoyaProvider<BoxOfficeAPI>
//    
//    init(provider: MoyaProvider<BoxOfficeAPI> = .init()) {
//        self.provider = provider
//    }
    
//    func fetchDailyBoxOffice(date: String) async throws -> [Movie] {
//        return try await withCheckedThrowingContinuation { continuation in
//            provider.request(.dailyBoxOffice(date: date)) { result in
//                switch result {
//                case .success(let response):
//                    do {
//                        let boxOfficeResponse = try response.map(BoxOfficeResponse.self)
//                        let movies = boxOfficeResponse.boxOfficeResult.dailyBoxOfficeList.map { movie in
//                            Movie(
//                                id: movie.rank,
//                                movieName: movie.movieName,
//                                audienceCount: movie.audienceCount,
//                                openDate: movie.openDate
//                            )
//                        }
//                        continuation.resume(returning: movies)
//                    } catch {
//                        continuation.resume(throwing: error)
//                    }
//                case .failure(let error):
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
//}
