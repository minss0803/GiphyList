//
//  ViewController.swift
//  GiphyList
//
//  Created by 민쓰 on 02/12/2019.
//  Copyright © 2019 민쓰. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ViewController<ViewBindable> : UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attribute()
        layout()
        
    }
    
    deinit {
        print("\(ViewBindable.self) 메모리 할당 해제됨")
    }
    
    func bind(_ viewModel: ViewBindable) {}
    
    func attribute() {}
    
    func layout() {}
    
    
    
    
}
