//
//  ViewController.swift
//  InfiniteBanner
//
//  Created by LLeven on 2019/5/28.
//  Copyright © 2019 lianleven. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let banner = InfiniteBanner()
//        banner.backgroundColor = UIColor.orange
        
        view.addSubview(banner)
//        banner.itemSize = CGSize(width: view.bounds.width, height: 160)
        banner.fill_width()
        banner.layout(constant: 200, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0)
        banner.height(160)
        banner.itemSize = CGSize(width: self.view.frame.width - 100, height: 160)
        banner.itemSpacing = -20;
        
        banner.items = [BannerItem(url: "https://p.ssl.qhimg.com/dmfd/400_300_/t0120b2f23b554b8402.jpg"),BannerItem(url: "https://gss1.bdstatic.com/-vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=571122a7b07eca8016053ee5a1229712/8d5494eef01f3a29c8f5514a9925bc315c607c71.jpg"),BannerItem(url: "https://pub-static.haozhaopian.net/static/web/site/features/cn/crop/images/crop_20a7dc7fbd29d679b456fa0f77bd9525d.jpg")]
    }


}

