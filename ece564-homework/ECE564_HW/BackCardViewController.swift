//
//  BackCardViewController.swift
//  ECE564_HW
//
//  Created by zjy on 3/18/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import UIKit

class BackCardViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    
    var photo : UIImage = UIImage(named: "blank")!
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImg.image = photo
        nameLabel.text = name
    }
}
