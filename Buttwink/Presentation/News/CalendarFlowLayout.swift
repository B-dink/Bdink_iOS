//
//  CalendarFlowLayout.swift
//  Buttwink
//
//  Created by MEGA_Mac on 2/26/25.
//

import UIKit

/// UICollectionViewFlowLayout
/// - Parameters:
///   - 페이징 자연스럽게 동작 처리
/// - Author: seungchan
final class CalendarFlowLayout: UICollectionViewFlowLayout {
    /// 스크롤이 끝났을 때 가장 가까운 월로 자동 정렬
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let pageWidth = collectionView.bounds.width
        let nearestPage = round(proposedContentOffset.x / pageWidth)
        let targetX = nearestPage * pageWidth
        return CGPoint(x: targetX, y: proposedContentOffset.y)
    }
}
