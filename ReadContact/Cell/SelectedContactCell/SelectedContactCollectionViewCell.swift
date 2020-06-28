//
//  SelectedContactCollectionViewCell.swift
//  World Album
//
//  Created by Shubham Sharma on 07/04/20.
//  Copyright © 2020 Arka. All rights reserved.
//

import UIKit

class SelectedContactCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var userProfilePic: UIImageView!
	@IBOutlet weak var userName: UILabel!
	@IBOutlet weak var closeBtn: UIButton!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	func configData(data: MyContact) {
		userName.text = "\(data.firstName) \(data.middleName) \(data.lastName)"
//		userProfilePic.sd_setImage(with: data.profile_image.getMediaUrl) { (image, error, cache, url) in
//			if error != nil {
//				self.userProfilePic.image = UIImage(named: "ic_placeholder_profile")
//			}
//		}
		
	}
	
}
