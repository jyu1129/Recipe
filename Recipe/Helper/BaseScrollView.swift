//
//  BaseScrollView.swift
//  Recipe
//
//  Created by Justin on 14/04/2022.
//

import UIKit

enum ScrollViewDirection {
    case horizontal
    case vertical
}

class BaseScrollView: UIScrollView {
    let contentView = UIView()
    var direction: ScrollViewDirection = .vertical
    
    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }
    
    required init(direction: ScrollViewDirection) {
        super.init(frame: .zero)
        
        self.direction = direction
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func setup() {
        addSubview(contentView)
    }
    
    private func addView() {
        if direction == .horizontal {
            alwaysBounceHorizontal = true
            alwaysBounceVertical = false
        } else {
            alwaysBounceHorizontal = false
            alwaysBounceVertical = true
        }
    }
    
    private func addConstraint() {
        if direction == .horizontal {
            contentView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
            }
        } else {
            contentView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
            }
        }
    }
}
