//
//  TopRatedTableViewCell.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-02.
//

import UIKit

class TopRatedTableViewCell: UITableViewCell
{
    //@IBOutlet weak var titleLabel: UILabel!
    //@IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var topRatedImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
