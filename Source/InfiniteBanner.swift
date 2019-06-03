//
//  InfiniteBanner.swift
//  InfiniteBanner
//
//  Created by LLeven on 2019/5/28.
//  Copyright © 2019 lianleven. All rights reserved.
//

import UIKit
import Kingfisher

public struct BannerItem {
    var imageUrl: String = ""
    public init (url: String) {
        self.imageUrl = url
    }
}

public protocol InfiniteBannerDelegate: class {
    func banner(_ banner: InfiniteBanner, didSelectItem item:BannerItem, atIndexPath indexPath: IndexPath)
}

open class InfiniteBanner: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup() {
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
        collectionView.register(InfiniteBannerCell.self, forCellWithReuseIdentifier: "InfiniteBannerCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.fill()
        
        timeInterval = 3
        itemSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
    }
    fileprivate func reportStatus() {
        let point = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
        guard var indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        indexPath = IndexPath(item: indexPath.row % (items.count / 3), section: indexPath.section)
    }
    
    // MARK: Timer
    fileprivate func setupTimer () {
        tearDownTimer()
        if (!self.autoScroll) { return }
        if (self.itemCount <= 1) { return }
        timer = Timer.init(timeInterval: TimeInterval(timeInterval), repeats: true, block: {[weak self] (timer) in
            guard let weakSelf = self else {
                return
            }
            let curOffset = weakSelf.collectionView.contentOffset.x
            let targetOffset = curOffset + weakSelf.itemSize.width + weakSelf.itemSpacing
            weakSelf.collectionView.setContentOffset(CGPoint(x: targetOffset, y: weakSelf.collectionView.contentOffset.y), animated: true)
        })
        RunLoop.main.add(timer!, forMode: .common)
    }
    fileprivate func tearDownTimer () {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionViewLayout: InfiniteBannerLayout = InfiniteBannerLayout()
    fileprivate var timer: Timer?
    fileprivate var itemCount: Int = 0
    public var autoScroll: Bool = true {
        didSet {
            setupTimer()
        }
    }
    public var timeInterval: Int = 3 {
        didSet {
            setupTimer()
        }
    }
    public var itemSize: CGSize = .zero{
        didSet {
            collectionViewLayout.itemSize = itemSize
        }
    }
    public var itemSpacing: CGFloat = 0{
        didSet {
            collectionViewLayout.minimumLineSpacing = itemSpacing
        }
    }
    public var placeholder: UIImage?
    public weak var delegate: InfiniteBannerDelegate?
    fileprivate var _items: [BannerItem] = []
    public var items: [BannerItem] {
        get{
            return _items
        }
        set {
            if newValue.count > 0 {
                itemCount = newValue.count
                _items.removeAll()
                for _ in 0..<3{
                    _items.append(contentsOf: newValue)
                }
                setupTimer()
                DispatchQueue.main.async {[weak self] in
                    self?.collectionView.reloadData()
                    DispatchQueue.main.async {[weak self] in
                        guard let weakSelf = self else {
                            return
                        }
                        if (weakSelf.collectionView.contentOffset.equalTo(.zero)) {
                            weakSelf.collectionView.scrollToItem(at: IndexPath(item: weakSelf.items.count - 1, section: 0), at: .centeredHorizontally, animated: false)
                        }
                    }
                    
                }
            }
        }
    }
}

extension InfiniteBanner: UICollectionViewDataSource, UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfiniteBannerCell", for: indexPath) as! InfiniteBannerCell
        let item = self.items[indexPath.row]
        cell.imageView.kf.setImage(with: URL(string: item.imageUrl), placeholder: placeholder)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.delegate?.banner(self, didSelectItem: item, atIndexPath: indexPath)
    }
    
    // MARK: UIScrollViewDelegate
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = itemSize.width + itemSpacing
        let periodOffset = pageWidth * CGFloat((items.count / 3))
        let offsetActivatingMoveToBeginning = pageWidth * CGFloat((items.count / 3) * 2);
        let offsetActivatingMoveToEnd = pageWidth * CGFloat((self.items.count / 3) * 1);
        
        let offsetX = scrollView.contentOffset.x;
        if (offsetX > offsetActivatingMoveToBeginning) {
            scrollView.contentOffset = CGPoint(x: (offsetX - periodOffset), y: 0);
        } else if (offsetX < offsetActivatingMoveToEnd) {
            scrollView.contentOffset = CGPoint(x: (offsetX + periodOffset),y: 0);
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tearDownTimer()
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        collectionView.contentOffset = collectionViewLayout.targetContentOffset(forProposedContentOffset: collectionView.contentOffset, withScrollingVelocity: .zero)
    }
}

