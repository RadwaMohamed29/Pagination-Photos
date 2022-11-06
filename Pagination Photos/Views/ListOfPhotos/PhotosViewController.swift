//
//  PhotosViewController.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import UIKit
import KRProgressHUD
import Kingfisher
protocol PhotosView: AnyObject {
    func reloadPhotosTableView()
}
class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var photosViewModel: PhotosViewModelType?
    @IBOutlet weak var photosTableView: UITableView!
    var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        photosTableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
        photosTableView.delegate = self
        photosTableView.dataSource = self
        photosViewModel = PhotosViewModel(self)
        print("no photos \(String(describing: photosViewModel?.returnPhotosCount()))")
        fetchData()
        
        
    }
    
    func fetchData(){
        photosViewModel?.callFuncToGetALlPhotos(completion: { isFinshed in
            if !isFinshed{
                KRProgressHUD.show()
            }else{
                KRProgressHUD.dismiss()
            }
            
        })
        photosViewModel?.getPhotos = {[weak self] _ in
            DispatchQueue.main.async {
                self?.photosTableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosViewModel?.returnPhotosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = photosTableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as? PhotosTableViewCell
        else{
            return UITableViewCell()
        }
        let item = photosViewModel?.getUsedPhotos(at: indexPath.row)
        cell.photoTitle.text = item?.title
        applyCirclePhoto(photo: cell.photoImageView)
        let url = URL(string: item?.url ?? "")
        cell.photoImageView.kf.setImage(with: url)
        imageView.applyshadowWithCorner(containerView: cell.cellView, cornerRadious: 25.0)
       

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        photosViewModel?.willDisplayPhoto(at: indexPath.row)

    }



}
extension PhotosViewController: PhotosView{
    func reloadPhotosTableView() {
        DispatchQueue.main.async {
            self.photosTableView.reloadData()
        }
    }
    

    
}
