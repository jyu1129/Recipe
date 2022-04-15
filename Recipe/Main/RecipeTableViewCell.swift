//
//  RecipeTableViewCell.swift
//  Recipe
//
//  Created by Justin on 11/04/2022.
//

import UIKit
import SnapKit

class RecipeTableViewCell: UITableViewCell {
    let stackViewContainer = UIStackView()
    let imageViewRecipe = UIImageView()
    let labelRecipe = UILabel()
    let labelRecipeType = UILabel()
    
    var recipe: Recipe? {
        didSet {
            if let recipe = recipe {
                imageViewRecipe.image = UIImage(data: recipe.image, scale: 1.0)
                labelRecipe.text = recipe.name
                labelRecipeType.text = recipe.category
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func prepareForReuse() {
        imageViewRecipe.image = UIImage()
        labelRecipe.text = ""
        labelRecipeType.text = ""
        
        super.prepareForReuse()
    }
    
    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        stackViewContainer.axis = .horizontal
        stackViewContainer.alignment = .fill
        stackViewContainer.distribution = .fill
        stackViewContainer.spacing = 15
        
        imageViewRecipe.contentMode = .scaleAspectFit
    }
    
    private func addView() {
        contentView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(imageViewRecipe)
        stackViewContainer.addArrangedSubview(labelRecipe)
        stackViewContainer.addArrangedSubview(labelRecipeType)
    }
    
    private func addConstraint() {
        stackViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
            make.leading.equalToSuperview().offset(margin)
            make.trailing.equalToSuperview().inset(margin)
           
        }
        
        imageViewRecipe.snp.makeConstraints { make in
            make.width.height.equalTo(75)
        }
    }
}
