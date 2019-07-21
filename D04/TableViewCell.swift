//
//  TableViewCell.swift
//  D04
//
//  Created by Yolankyi SERHII on 6/28/19.
//  Copyright © 2019 Yolankyi SERHII. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UILabel!
}
