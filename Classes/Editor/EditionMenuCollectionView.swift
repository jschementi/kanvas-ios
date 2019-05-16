//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

private struct EditionMenuCollectionViewConstants {
    static var height: CGFloat =  EditionMenuCollectionCell.height
}

/// Collection view for EditionMenuCollectionController
final class EditionMenuCollectionView: IgnoreTouchesView {
    
    static let height = EditionMenuCollectionViewConstants.height
    let collectionView: IgnoreTouchesCollectionView
    let fadeOutGradient = CAGradientLayer()
    
    init() {
        collectionView = createCollectionView()
        
        super.init(frame: .zero)
        
        clipsToBounds = false
        setUpViews()
    }
    
    @available(*, unavailable, message: "use init() instead")
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @available(*, unavailable, message: "use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFadeOutEffect() {
        fadeOutGradient.frame = bounds
    }
}

// MARK: - Layout
extension EditionMenuCollectionView {
    
    private func setUpViews() {
        collectionView.add(into: self)
        collectionView.clipsToBounds = false
        setFadeOutGradient()
    }
    
    private func setFadeOutGradient() {
        fadeOutGradient.frame = bounds
        fadeOutGradient.colors = [UIColor.clear.cgColor,
                                  UIColor.white.cgColor,
                                  UIColor.white.cgColor,
                                  UIColor.clear.cgColor]
        fadeOutGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        fadeOutGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        fadeOutGradient.locations = [0, 0.02, 0.9, 1.0]
        layer.mask = fadeOutGradient
    }
}

// MARK: - Collection
fileprivate func createCollectionView() -> IgnoreTouchesCollectionView {
    let layout = UICollectionViewFlowLayout()
    configureCollectionLayout(layout: layout)
    
    let collectionView = IgnoreTouchesCollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.accessibilityIdentifier = "Edition Menu Collection"
    collectionView.backgroundColor = .clear
    configureCollection(collectionView: collectionView)
    return collectionView
}

fileprivate func configureCollectionLayout(layout: UICollectionViewFlowLayout) {
    layout.scrollDirection = .horizontal
    layout.itemSize = UICollectionViewFlowLayout.automaticSize
    layout.estimatedItemSize = CGSize(width: EditionMenuCollectionCell.width, height: EditionMenuCollectionCell.height)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
}

fileprivate func configureCollection(collectionView: IgnoreTouchesCollectionView) {
    collectionView.isScrollEnabled = false
    collectionView.allowsSelection = true
    collectionView.bounces = true
    collectionView.alwaysBounceHorizontal = true
    collectionView.alwaysBounceVertical = false
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.showsVerticalScrollIndicator = false
    collectionView.autoresizesSubviews = true
    collectionView.contentInset = .zero
    collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    collectionView.dragInteractionEnabled = true
    collectionView.reorderingCadence = .immediate
}
