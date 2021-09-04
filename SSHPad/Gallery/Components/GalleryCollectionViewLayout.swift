//
//  GalleryCollectionViewLayout.swift
//  SSHPad
//
//  Created by Tomas Martins on 03/09/21.
//

import UIKit

class GalleryCollectionViewLayout: UICollectionViewFlowLayout {
    let cellsPerRow: Int
    
    init(cellsPerRow: Int = 5, minimumInteritemSpacing: CGFloat = 10, minimumLineSpacing: CGFloat = 10, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        var marginsAndInsets: CGFloat
        if #available(iOS 11.0, *) {
            marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        } else {
            marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.contentInset.left + collectionView.contentInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
            
        }
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
