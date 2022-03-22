//
//  DetailsViewController.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-19.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var art: PhotoModel?
    
    @IBOutlet weak var userProfilePhoto: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareView()
    }
    
}

// MARK: - Configuration 
extension DetailsViewController {
    private func prepareView() {
        guard let art = art else { return }
        
        title = "Photo Details"
        userProfilePhoto.layer.cornerRadius = userProfilePhoto.frame.size.width/2
        containerView.layer.cornerRadius = 6
        
        userProfilePhoto.image = art.profileImage
        username.text = "@\(art.username)"
        views.text = art.views
        
        getLargePhoto(from: art.imageUrl)
    }
}

// MARK: - Networking
extension DetailsViewController {
    private func getLargePhoto(from url: String) {
        ImageProvider.instance.fetchPhoto(from: url, completion: { [weak self] result in
            switch result {
            case .success(let image):
                self?.spinner.startAnimating()
                
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.spinner.stopAnimating()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.spinner.stopAnimating()
                }
            }
        })
    }
}
