//
//  UIView+Extension.swift
//  GiphyList
//
//  Created by 민쓰 on 08/01/2020.
//  Copyright © 2020 민쓰. All rights reserved.
//

import UIKit

// MARK: - AutoLayout Anchor 설정
extension UIView {
    var makeConstraints: UIView {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    var remakeConstraints: UIView {
        self.removeAllConstraints()
        return self
    }
    
    
    @discardableResult
    func top(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0, priority:Float = 1000) -> Self {
        let anchor = anchor ?? superview!.topAnchor
        let constraint = topAnchor.constraint(equalTo: anchor, constant: c)
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
    }
    @discardableResult
    func leading(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0, priority:Float = 1000) -> Self {
        let anchor = anchor ?? superview!.leadingAnchor
        let constraint = leadingAnchor.constraint(equalTo: anchor, constant: c)
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
    }
    @discardableResult
    func bottom(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0, priority:Float = 1000) -> Self {
        let anchor = anchor ?? superview!.bottomAnchor
        let constraint = bottomAnchor.constraint(equalTo: anchor, constant: c)
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
    }
    @discardableResult
    func trailing(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0, priority:Float = 1000) -> Self {
        let anchor = anchor ?? superview!.trailingAnchor
        let constraint = trailingAnchor.constraint(equalTo: anchor, constant: c)
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
    }
    @discardableResult
    func centerY(equalTo anchor: NSLayoutYAxisAnchor? = nil, constant c: CGFloat = 0, priority:Float = 1000) -> Self {
        let anchor = anchor ?? superview!.centerYAnchor
        let constraint = centerYAnchor.constraint(equalTo: anchor, constant: c)
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
    }
    @discardableResult
    func centerX(equalTo anchor: NSLayoutXAxisAnchor? = nil, constant c: CGFloat = 0, priority:Float = 1000) -> Self {
        let anchor = anchor ?? superview!.centerXAnchor
        let constraint = centerXAnchor.constraint(equalTo: anchor, constant: c)
        constraint.priority = UILayoutPriority(priority)
        constraint.isActive = true
        return self
    }
    @discardableResult
    func height(equalTo anchor: NSLayoutDimension? = nil, constant c: CGFloat = 0, multiplier m: CGFloat = 1, priority:Float = 1000) -> Self {
        if let superview = superview {
            if c == 0 {
                let anchor = anchor ?? superview.heightAnchor
                let constraint = heightAnchor.constraint(equalTo: anchor, multiplier: m, constant: c)
                constraint.priority = UILayoutPriority(priority)
                constraint.isActive = true
            } else {
                // FIXME: - contant 에 값을 주면 전체 높이에서 계산되는 문제
                let constraint = heightAnchor.constraint(equalToConstant: c)
                constraint.priority = UILayoutPriority(priority)
                constraint.isActive = true
            }
            return self
        } else {
            print("오토레이아웃을 설정하기 위한 부모뷰가 없습니다.")
            fatalError()
        }
    }
    @discardableResult
    func width(equalTo anchor: NSLayoutDimension? = nil, constant c: CGFloat = 0, multiplier m: CGFloat = 1, priority:Float = 1000) -> Self {
        if let superview = superview {
            if c == 0 {
                let anchor = anchor ?? superview.widthAnchor
                let constraint = widthAnchor.constraint(equalTo: anchor, multiplier: m, constant: c)
                constraint.priority = UILayoutPriority(priority)
                constraint.isActive = true
            } else {
                let constraint = widthAnchor.constraint(equalToConstant: c)
                constraint.priority = UILayoutPriority(priority)
                constraint.isActive = true
            }
            return self
        } else {
            print("오토레이아웃을 설정하기 위한 부모뷰가 없습니다.")
            fatalError()
        }
    }
    
    func equalToSuperView() {
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        } else {
            print("오토레이아웃을 설정하기 위한 부모뷰가 없습니다.")
            fatalError()
        }
    }
    
    private func removeAllConstraints() {
        removeConstraints(constraints)
    }
}
