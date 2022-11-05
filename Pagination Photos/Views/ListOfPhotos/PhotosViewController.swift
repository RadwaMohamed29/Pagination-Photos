//
//  PhotosViewController.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var photosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        photosTableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
        photosTableView.delegate = self
        photosTableView.dataSource = self
        
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = photosTableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as? PhotosTableViewCell
        else{
            return UITableViewCell()
            
        }
        return cell
    }
    

}
