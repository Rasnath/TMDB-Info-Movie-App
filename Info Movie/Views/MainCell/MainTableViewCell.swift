//
//  TableViewCell.swift
//  Info Movie
//
//  Created by Fábio Silva  on 23/08/2022.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    @IBOutlet weak var image6: UIImageView!
    
    static let identifier = "MainTableViewCell"
    
    static func nib() -> UINib{
        return UINib(nibName: "MainTableViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image1.isUserInteractionEnabled = true
        image2.isUserInteractionEnabled = true
        image3.isUserInteractionEnabled = true
        image4.isUserInteractionEnabled = true
        image5.isUserInteractionEnabled = true
        image6.isUserInteractionEnabled = true
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with model: [MovieModel], at indexPath: Int, isLandscape: Bool){
        
       var imageIndex = indexPath * 3
        image4.isHidden = true
        image5.isHidden = true
        image6.isHidden = true
        if isLandscape {
            image4.isHidden = false
            image5.isHidden = false
            image6.isHidden = false
            imageIndex = indexPath * 6
        }
        
        if imageIndex < model.count{
            image1.image = model[imageIndex].posterImage
            image1.tag = imageIndex
        }
        if imageIndex + 1 < model.count{
            image2.image = model[imageIndex+1].posterImage
            image2.tag = imageIndex+1
        }
        if imageIndex + 2 < model.count {
            image3.image = model[imageIndex+2].posterImage
            image3.tag = imageIndex+2
        }
        if isLandscape {
            if imageIndex + 3 < model.count{
                image4.image = model[imageIndex+3].posterImage
                image4.tag = imageIndex+3
            }
            if imageIndex + 4 < model.count {
                image5.image = model[imageIndex+4].posterImage
                image5.tag = imageIndex+4
            }
            if imageIndex + 5 < model.count {
                image6.image = model[imageIndex+5].posterImage
                image6.tag = imageIndex+5
            }
        }
    }
    
}
