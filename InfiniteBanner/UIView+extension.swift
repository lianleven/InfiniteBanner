//
//  UIView+extension.swift
//  InfiniteBanner
//
//  Created by LLeven on 2019/5/28.
//  Copyright © 2019 lianleven. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @discardableResult
    func height(_ constant: CGFloat = 0) -> NSLayoutConstraint {
        return layout(constant: constant, attribute: .height, toItem: nil, attribute: .notAnAttribute)
    }
    @discardableResult
    func width(_ constant: CGFloat = 0) -> NSLayoutConstraint {
        return layout(constant: constant, attribute: .width, toItem: nil, attribute: .notAnAttribute)
    }
    
    func size(_ size: CGSize = CGSize.zero) {
        height(size.height)
        width(size.width)
    }
    
    func fill() {
        edgeInsets()
    }
    func fill_height() {
        layout(attribute: .top, toItem: superview, attribute: .top)
        layout(attribute: .bottom, toItem: superview, attribute: .bottom)
    }
    func fill_width() {
        layout(attribute: .left, toItem: superview, attribute: .left)
        layout(attribute: .right, toItem: superview, attribute: .right)
    }
    
    func edgeInsets(_ insets: UIEdgeInsets = .zero) {
        layout(constant: insets.left, attribute: .left, toItem: superview, attribute: .left)
        layout(constant: insets.right, attribute: .right, toItem: superview, attribute: .right)
        layout(constant: insets.top, attribute: .top, toItem: superview, attribute: .top)
        layout(constant: insets.bottom, attribute: .bottom, toItem: superview, attribute: .bottom)
    }
    
    
    @discardableResult
    func layout(constant c: CGFloat = 0, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem view2: Any?, attribute attr2: NSLayoutConstraint.Attribute, multiplier: CGFloat = 1.0) -> NSLayoutConstraint {
        guard let superview = superview else {
            assert(false, "superview is nil")
        }
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint.init(item: self, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attr2, multiplier: multiplier, constant: c)
        superview.addConstraint(constraint)
        
        return constraint
    }
}