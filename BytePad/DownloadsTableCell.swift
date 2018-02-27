//
//  DownloadsTableCell.swift
//  BytePad
//

//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit

class DownloadsTableCell: UITableViewCell {
    
    @IBOutlet weak var paperNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    var fileURL: String!
    
    func initCell(_ paperName: String, detail: String, fileURL: String)  {
        self.paperNameLabel.text = paperName
        self.detailLabel.text = detail
        self.fileURL = fileURL
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
