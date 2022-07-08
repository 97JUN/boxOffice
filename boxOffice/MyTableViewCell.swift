//
//  MyTableViewCell.swift
//  boxOffice
//
//  Created by 쭌이 on 2022/07/05.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var movieName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
