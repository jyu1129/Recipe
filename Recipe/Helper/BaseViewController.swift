//
//  BaseViewController.swift
//  Recipe
//
//  Created by Justin on 11/04/2022.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    let safeAreaView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addView()
        addConstraint()
    }
    
    private func setup() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    }
    
    private func addView() {
        view.addSubview(safeAreaView)
    }
    
    private func addConstraint() {
        safeAreaView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
