//
//  SavedTableViewCell.swift
//  GoldenCinema
//
//  Created by iMac on 2022-09-07.
//

import UIKit

class SavedTableViewCell: UITableViewCell
{
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    
    @IBOutlet weak var savedImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
