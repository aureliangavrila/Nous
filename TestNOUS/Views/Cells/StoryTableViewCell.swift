//
//  StoryTableViewCell.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 07.12.2022.
//

import UIKit
import Kingfisher

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storyImageView: UIImageView!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        storyImageView.clipsToBounds = true
        storyImageView.layer.cornerRadius = storyImageView.frame.height/2
    }
    
    func configureCellWith(story: Story) {
        storyImageView.kf.setImage(with: URL(string: story.imageUrl))
        storyTitleLabel.text = story.title
        storyDescriptionLabel.text = story.description
    }
    
}
