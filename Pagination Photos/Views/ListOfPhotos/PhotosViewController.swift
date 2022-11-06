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
class PhotosViewController: UIViewController{
    var photosViewModel: PhotosViewModelType?
    @IBOutlet weak var photosTableView: UITableView!
    var imageView = UIImageView()
    var list: [Photo] = []
    private  var isConn:Bool = false
    private  let refreshController = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        photosTableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotosTableViewCell")
        photosTableView.delegate = self
        photosTableView.dataSource = self
        photosViewModel = PhotosViewModel(self)
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        photosTableView.addSubview(refreshController)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        checkConnection()
    }
    func checkConnection(){
        HandelConnection.handelConnection.checkNetworkConnection { [self] isConnected in
            isConn = isConnected
            if isConnected{
                self.fetchData()
            }else{
                showSnackBar()
                do{
                    try self.photosViewModel?.getAllPhotosFromCoreData(completion: { response in
                        switch response{
                        case true:
                            print("data retrived successfuly")
                        case false:
                            print("data cant't retrieved")
                        }}
                                                                       
                    )
                }
                catch let error{
                    print(error.localizedDescription)
                }
                self.list = self.photosViewModel?.photoList ?? []
                self.photosTableView.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.refreshController.endRefreshing()
            }
        }
        
    }
    @objc func pullToRefresh(){
        refreshController.beginRefreshing()
        checkConnection()
        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
            if self.refreshController.isRefreshing{
                self.refreshController.endRefreshing()
            }
        }
        
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
    
    
}
extension PhotosViewController:  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isConn == true{
            return photosViewModel?.returnPhotosCount() ?? 0
        }else{
            return list.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = photosTableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as? PhotosTableViewCell
        else{
            return UITableViewCell()
        }
        
        if isConn{
            let item = photosViewModel?.getUsedPhotos(at: indexPath.row)
            cell.photoTitle.text = item?.title
            let url = URL(string: item?.url ?? "")
            cell.photoImageView.kf.setImage(with: url)
        }else{
            cell.photoTitle.text = list[indexPath.row].title
            let url = URL(string: list[indexPath.row].url ?? "")
            cell.photoImageView.kf.setImage(with: url)
        }
        applyCirclePhoto(photo: cell.photoImageView)
        imageView.applyshadowWithCorner(containerView: cell.cellView, cornerRadious: 25.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        do {
            try photosViewModel?.saveToCoreData(title: photosViewModel?.getUsedPhotos(at: indexPath.row).title ?? "", url: photosViewModel?.getUsedPhotos(at: indexPath.row).url ?? "", completion: {response in
                switch response{
                case true:
                    print("Added Successfully")
                case false:
                    print("can not add to core data")
                }})
        }
        
        catch let error{
            print(error.localizedDescription)
        }
        
        
        photosViewModel?.willDisplayPhoto(at: indexPath.row)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let photoDetailsVC = storyboard?.instantiateViewController(withIdentifier: "PhotoDetailsViewController" ) as? PhotoDetailsViewController{
            photoDetailsVC.Url = photosViewModel?.getUsedPhotos(at: indexPath.row).url
            navigationController?.pushViewController(photoDetailsVC, animated: true)
        }
    }
    
    
    
}
extension PhotosViewController: PhotosView{
    func reloadPhotosTableView() {
        DispatchQueue.main.async {
            self.photosTableView.reloadData()
        }
    }
    
    
    
}
