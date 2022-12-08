//
//  StoryTableViewCell.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 07.12.2022.
//

import UIKit
import Kingfisher

struct StoryTableViewCellModel: TableViewCellModelType {
    var identifier: String { String(describing: StoryTableViewCell.self) }
    
    let title: String
    let description: String
    let imageUrl: String
}

class StoryTableViewCell: UITableViewCell, TableViewCellType {
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        storyImageView.clipsToBounds = true
        storyImageView.layer.cornerRadius = storyImageView.frame.height/2
    }
    
    func update(with model: TableViewCellModelType) {
        guard let model = model as? StoryTableViewCellModel else { return }
        
        storyImageView.kf.setImage(with: URL(string: model.imageUrl))
        storyTitleLabel.text = model.title
        storyDescriptionLabel.text = model.description
    }
    
}
