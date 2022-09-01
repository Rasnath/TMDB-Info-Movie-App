//
//  CollectionViewCell.swift
//  Info Movie
//
//  Created by Fábio Silva  on 25/08/2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var castImage: UIImageView!
    @IBOutlet weak var castLabel: UILabel!
    
    static let identifier = "CollectionViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "CollectionViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: CastModel){
        castImage.image = model.castImage
        castLabel.text = model.castName
    }

}
