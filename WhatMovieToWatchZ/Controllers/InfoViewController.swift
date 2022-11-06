//
//  InfoViewController.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import UIKit

/// Le viewcontroller d' information d'un film
class InfoViewController: UIViewController {
    
    /// Le résumé du film
    @IBOutlet weak var overViewLabel: UILabel!
    /// L'image du film
    @IBOutlet weak var backDropImageView: UIImageView!
    /// Le titre du film
    @IBOutlet weak var movieTitle: UILabel!
    /// La phrase d'accroche du film
    @IBOutlet weak var movieTagLine: UILabel!
    /// La note du film définit par les utilisateurs
    @IBOutlet weak var ratingLabel: UILabel!
    /// L'année de sortie du film
    @IBOutlet weak var yearLabel: UILabel!
    /// Les acteurs du film définits dans une collection view
    @IBOutlet weak var CastColletionView: UICollectionView!
    /// Stack view regroupant la totalité de la page informations
    @IBOutlet weak var stackView: UIStackView!
    
    /// Une instance de la requete qui s'occupe d'obtenir les données d'un film sur l'API
    private var infoMovieManager = InfoMovieManager()
  
    /// Une variable id en INt
    var id: Int?
     
    /// Une instance de CastModel
    private var castImages = [CastModel]()
    /// L'id du film en string
    private var trailerID = ""
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        /// La stackView est cachée au lancement de l'app pour optimiser les performances
        stackView.isHidden = true

        /// On applique le délégué sur infoMovieManager
        infoMovieManager.delegate = self
        
        /// Si le mobile est en mode paysage on met la stack view horizontal
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
            /// Sinon verticale
        } else {
            stackView.axis = .vertical
        }
        
        /// Si l'id est vérifié
        if let id = self.id{
            /// On appelle la fonction search movie qui s'occupe de faire la requête sur l'api
            infoMovieManager.searchMovie(id: id)
        }
     
        /// Sur la collection view on enregistre le fichier nib voulu et son identifiant
        CastColletionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        CastColletionView.delegate = self
        CastColletionView.dataSource = self
}
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
        
    }
    
  
}

//MARK: - InfoMovieManagerDelegate
/// Extension d'info view controller qui se conforme au protocole d'info movie manager et donc de ses fonctions
extension InfoViewController: InfoMovieManagerDelegate{
    /// On reprend donc la fonction didUpdateMovie pour
    func didUpdateMovie(_ movieManager: InfoMovieManager, movie: InfoMovieModel) {
        DispatchQueue.main.async {
            /// On applique les donnée reçues de la phrase d'accroche et on l'affecte à movieTagLine
            self.movieTagLine.text = movie.tagLine
            /// On applique les donnée reçues du titre et on l'affecte à movieTitle
            self.movieTitle.text = movie.title
            /// Si l'image du film est vérifiée
            if let backDropImage = movie.backdropImage {
                /// On applique les données reçues et on l'affecte à backDropImageView
                self.backDropImageView.image = backDropImage
            }
            /// On applique les donnée reçues du synopsys  et on l'affecte à overViewLabel
            self.overViewLabel.text = movie.overView
            self.castImages = movie.castInfo

    
            self.yearLabel.text = String(movie.releaseDate.prefix(4))
            self.ratingLabel.text = String(format: "%.2f", movie.voteAverage)
            self.CastColletionView.reloadData()
            self.stackView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension InfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: castImages[indexPath.row])
        return cell
    }
   
}
