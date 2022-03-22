//
//  ViewController.swift
//  FlickrSearchApp
//
//  Created by Amir Bakhshi on 2022-03-18.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var fetchedArts = [PhotoModel]()
    
    private var query = "night"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupCollectionViewItemSize()
        startFetchPhotos(for: query)
    }
    
}

// MARK: - Networking
extension HomeViewController {
    private func startFetchPhotos(for keyword: String) {
        
        NetworkService.instance.sendReguest(for: keyword, completion: { [weak self] result in
            switch result {
            case .success(let arts):
                guard let arts = arts else { return }
                self?.spinner.startAnimating()
                self?.fetchedArts = arts
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                    self?.spinner.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}

// MARK: - UICollectionView Methods
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedArts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        cell.configure(image: fetchedArts[indexPath.row].image)
        return cell
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArt = fetchedArts[indexPath.row]
        showDetailsFor(art: selectedArt)
    }
    
}

// MARK: - LayoutDelegate Methods 
extension HomeViewController: CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
        return fetchedArts[indexPath.row].image.size
    }
}

// MARK: - UIConfiguration
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let keyword = searchBar.text {
            fetchedArts.removeAll()
            query = keyword
            startFetchPhotos(for: keyword)
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: ItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        searchBar.searchTextField.textColor = .white
    }
    
    private func setupCollectionViewItemSize() {
        let customLayout = CustomLayout()
        customLayout.delegate = self
        collectionView.collectionViewLayout = customLayout
    }
    
    private func showDetailsFor(art: PhotoModel) {
        let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.art = art
        navigationItem.backButtonTitle = " "
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
