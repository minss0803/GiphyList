//
//  FavoriteButton.swift
//  GiphyList
//
//  Created by 민쓰 on 04/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit

enum FavoriteState {
    case favorited, notFavorited
}

class FavoriteButton: UIButton {
    
    let image = UIImage(named: "star")
    var favoriteState: FavoriteState? {
        didSet {
            if favoriteState == .notFavorited {
                self.tintColor = .gray
            } else {
                self.tintColor = .yellow
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        self.do {
            $0.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.favoriteState = .notFavorited
        }
    }
    
    func layout() {}
}
