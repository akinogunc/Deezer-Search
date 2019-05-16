//
//  DZRArtistSearchViewController.swift
//  DeezerExercice
//
//  Created by AKIN on 10.05.2019.
//  Copyright © 2019 Deezer. All rights reserved.
//

import UIKit

class DZRSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchResultMessage: UILabel!
    var viewModel = DZRSearchViewModel()
    var searchTimer: Timer?

    var searchText: String = "" {
        didSet {
            self.viewModel.searchArtists(query: self.searchText) {response in
                DispatchQueue.main.sync {
                    self.collectionView.reloadData()
                    self.showMessage(response: response)
                }
            }
        }
    }
    
    func searchThrottle(){
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.viewModel.clearArtists { self.collectionView.reloadData() }
            if self.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces).count == 0 { return }
            self.showLoading()
            self.searchText = self.searchBar.text!
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarCustomization()
        collectionViewCustomization()
    }
    
    // MARK: - UICollectionView delegate methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.artists.count == 0 ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? DZRCollectionViewSectionHeader{
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "ArtistCollectionViewCellIdentifier"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! DZRArtistCollectionViewCell

        //cleanup for dequeue
        cell.artistImage.image = UIImage(named: "empty_artist.jpg")
        
        if viewModel.artists.count > 0 {
            let artist = viewModel.artists[indexPath.row]
            cell.configure(model: artist)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        searchBar.resignFirstResponder()
        
        let cell = collectionView.cellForItem(at: indexPath) as! DZRArtistCollectionViewCell
        let detailViewModel = DZRDetailViewModel(id: cell.artistIdentifier, type: .albumDetail)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumViewController = storyboard.instantiateViewController(withIdentifier: "detail") as! DZRDetailViewController
        albumViewController.viewModel = detailViewModel
        self.navigationController?.pushViewController(albumViewController, animated: true)

    }
    
    func collectionViewCustomization(){
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }
    
    // MARK: - UISearchBar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchThrottle()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchThrottle()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.clearArtists {
            self.collectionView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarCustomization() {
        if let textField = searchBar.value(forKey: "_searchField") as? UITextField {
            textField.backgroundColor = .clear
            textField.clearButtonMode = .never
            textField.font = UIFont(name: "Avenir-Book", size: 14)
            
            if let textFieldLabel = textField.value(forKey: "placeholderLabel") as? UILabel{
                textFieldLabel.font = UIFont(name: "Avenir-Book", size: 14)
            }
        }
        
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : UIColor.lightGray,
                                                           NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 16)!]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
    }

    // MARK: - Search Result Messages
    
    func showMessage(response : ServiceResponse){
        switch response {
        case .success( _):
            hideLoading()
        case .failure:
            showNoResultMessage()
        case .notConnectedToInternet:
            showNoInternetMessage()
        }
    }
    
    func showLoading(){
        loadingView.isHidden = false
        activityIndicator.isHidden = false
        searchResultMessage.text = "Loading..."
    }
    
    func showNoResultMessage(){
        loadingView.isHidden = false
        activityIndicator.isHidden = true
        searchResultMessage.text = "No results"
    }
    
    func showNoInternetMessage(){
        loadingView.isHidden = false
        activityIndicator.isHidden = true
        searchResultMessage.text = "No internet connnection"
    }

    func hideLoading(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
            self.loadingView.isHidden = true
        })
    }

}


