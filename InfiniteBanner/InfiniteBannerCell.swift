//
//  InfiniteBannerCell.swift
//  InfiniteBanner
//
//  Created by LLeven on 2019/5/28.
//  Copyright © 2019 lianleven. All rights reserved.
//

import UIKit

class InfiniteBannerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        contentView.backgroundColor = .clear
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.fill()
    }
    
    var imageView: UIImageView!
}
