//
//  ContactTableViewCell.swift
//  World Album
//
//  Created by Shubham Sharma on 07/04/20.
//  Copyright © 2020 Arka. All rights reserved.
//

import UIKit
class ContactTableViewCell: UITableViewCell {
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var userMobile: UILabel!
	@IBOutlet weak var userProfilePic: UIImageView!
	
	@IBOutlet weak var checkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	func configData(data: MyContact) {
		userName.text = "\(data.firstName) \(data.middleName) \(data.lastName)"
		userMobile.text = data.mobile
//		userProfilePic.sd_setImage(with: data.profile_image.getMediaUrl) { (image, error, cache, url) in
//			if error != nil {
//				self.userProfilePic.image = UIImage(named: "ic_placeholder_profile")
//			}
//		}
		if data.is_selected {
			checkImageView.image = UIImage(named: "ic_checked")
		}else{
			checkImageView.image = UIImage(named: "ic_unchecked")
		}
	}
}
