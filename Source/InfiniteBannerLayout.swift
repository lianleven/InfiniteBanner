//
//  InfiniteBannerLayout.swift
//  InfiniteBanner
//
//  Created by LLeven on 2019/5/28.
//  Copyright © 2019 lianleven. All rights reserved.
//

import UIKit

open class InfiniteBannerLayout: UICollectionViewFlowLayout {

    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView  else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionView.frame.width * 0.5
        guard let layoutAttributesForElements = self.layoutAttributesForElements(in: collectionView.bounds), var layoutAttributes = layoutAttributesForElements.first else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        for element in layoutAttributesForElements {
            if (element.representedElementCategory != .cell) {
                continue;
            }
            
            let distance1 = element.center.x - proposedContentOffsetCenterX;
            let distance2 = layoutAttributes.center.x - proposedContentOffsetCenterX;
            
            if (abs(distance1) < abs(distance2)) {
                layoutAttributes = element;
            }
        }
        return CGPoint(x: layoutAttributes.center.x - collectionView.frame.width * 0.5, y: proposedContentOffset.y)
    }
}
