//
//  InfiniteBanner.swift
//  InfiniteBanner
//
//  Created by LLeven on 2019/5/28.
//  Copyright © 2019 lianleven. All rights reserved.
//

import UIKit
import SDWebImage

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
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let _ = self.window else {
            return
        }
        collectionView.contentOffset = collectionViewLayout.targetContentOffset(forProposedContentOffset: collectionView.contentOffset, withScrollingVelocity: .zero)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        collectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue);
        
        itemSize = self.frame.size;
        itemSpacing = 0;
        collectionView.fill()
        collectionView.layoutIfNeeded()
        timeInterval = 5
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidChangeStatusBarOrientationNotification), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    @objc fileprivate func applicationDidChangeStatusBarOrientationNotification () {
        collectionView.contentOffset = collectionViewLayout.targetContentOffset(forProposedContentOffset: collectionView.contentOffset, withScrollingVelocity: .zero)
    }
    
    // MARK: Timer
    fileprivate func setupTimer () {
        tearDownTimer()
        if (!self.autoScroll) { return }
        if (self.itemCount <= 1) { return }
        timer = Timer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    @objc fileprivate func timerAction() {
        let curOffset = self.collectionView.contentOffset.x
        let targetOffset = curOffset + self.itemSize.width + self.itemSpacing
        self.collectionView.setContentOffset(CGPoint(x: targetOffset, y: self.collectionView.contentOffset.y), animated: true)
    }
    fileprivate func tearDownTimer () {
        timer?.invalidate()
        timer = nil
    }
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var collectionViewLayout: InfiniteBannerLayout = InfiniteBannerLayout()
    fileprivate var timer: Timer?
    fileprivate var itemCount: Int = 0
    public var animation: Bool = true
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
    public var setBannerImage:((_ url: String) -> UIImage)?
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
                        guard let self = self else {
                            return
                        }
                        let curOffset = self.collectionView.contentOffset.x
                        let targetOffset = curOffset + self.itemSize.width + self.itemSpacing
                        self.collectionView.setContentOffset(CGPoint(x: targetOffset, y: self.collectionView.contentOffset.y), animated: true)
                        
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
        
//        cell.imageView.image = setBannerImage?(item.imageUrl)
        cell.imageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: placeholder)
        cell.imageView.layer.cornerRadius = 4;
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
        if !animation {
            return
        }
        for cell in collectionView.visibleCells {
            let centerPoint = self.convert(cell.center,from: scrollView)
            let d = abs(centerPoint.x - scrollView.frame.width * 0.5) / itemSize.width
            let scale = 1 - 0.2 * d
            cell.layer.transform = CATransform3DMakeScale(scale, scale, 1)
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
