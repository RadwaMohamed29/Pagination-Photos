//
//  PhotoDetailsViewController.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import UIKit

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var image: UIImageView!
    var Url: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: Url ?? "")
       image.kf.setImage(with: url)
    

}
}
