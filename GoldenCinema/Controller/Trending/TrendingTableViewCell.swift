//
//  TrendingTableViewCell.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-05.
//

import UIKit

class TrendingTableViewCell: UITableViewCell
{
    @IBOutlet weak var trendingTitleLabel: UILabel!
    @IBOutlet weak var trendingReleaseDateLabel: UILabel!
    @IBOutlet weak var trendingPopularityLabel: UILabel!
    @IBOutlet weak var trendingVoteAverageLabel: UILabel!
    @IBOutlet weak var trendingImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
