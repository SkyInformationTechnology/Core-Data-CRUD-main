//
//  ItemTableViewCell.swift
//  Core Data CRUD
//
//  Created by Md Akash on 15/1/24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configurateTheCell(_ items: Item) {
        itemNameLabel.text = items.name
    }
}
