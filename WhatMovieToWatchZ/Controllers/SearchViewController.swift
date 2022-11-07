//
//  TableViewController.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//
import UIKit

/// Controller de la classe de recherche qui hérite de UITableViewController
    class SearchViewController: UITableViewController {
    /// Variable qui est une instance de la struct MovieManager
    private var movieManager = MovieManager()
    /// Instanciation de la structure MovieModel
    private var movieModel = [MovieModel]()
    /// L'id du tag
    private var idTag: Int?
    /// Mode Paysage de base à faux
    private var isLandscape = false
    /// La variable, une méthode pour filtrer les films
    private var filterMethod = "search/movie"
    /// La requête une chaine de caractere vide
    private var query = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    /// Sur la table view on enregistre le fichier nib MainTableViewCell, en parametre on précise l'identifiant
        tableView.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifier)
    }
        /// Function de transition
    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        isLandscape = UIDevice.current.orientation.isLandscape
        tableView.reloadData()
    }
    // MARK: - Table view data source
        /// TableView configuration pour le nombre de lignes affichées
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if you need to upload all the images in the future
        //        let numberOfLines = Double(movieModel.count)/3
        //        return Int(ceil(numberOfLines))
        /// Nombre de ligne
        var numberRows: Int

        /// Si landscape est vérifié ( false de base , donc on rentre dans la condition )
        if isLandscape {
            /// On initialise le nombre de données affichées à 6
            numberRows = movieModel.count/6
        } else {
            /// Sinon on laisse à 3 par lignes
            numberRows = movieModel.count/3
        }
        /// Puis on retourne la variable après la condition
        return numberRows
    }
        /// Fonction de table view pour la taille des cellules reçues quand on tape une recherche
        override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           var rowHight: CGFloat
            /// Si le mode paysage est vérifié
            if isLandscape {
                /// On choisi la taille de la cellule, 0.25
                rowHight = 0.25 * self.view.safeAreaFrame.width
            } else {
                rowHight = 0.5 * self.view.safeAreaFrame.width
            }
            return rowHight
         }
        /// Demande à la source de données une cellule à insérer à un emplacement particulier de la vue de tableau.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Sur la tableView on utilise dequeueReusableCell pour recuperer la cellule
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        /// Une creation de reconaissance de geste qui prend en parametre la taget et l'action
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image1.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image2.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image3.addGestureRecognizer(tapGestureRecognizer3)
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image4.addGestureRecognizer(tapGestureRecognizer4)
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image5.addGestureRecognizer(tapGestureRecognizer5)
        /// Il y aura maximum 6 affiches de films affichées par lignes
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image6.addGestureRecognizer(tapGestureRecognizer6)
        /// Sur la cellule on applique la fonction configure crée dans le MainTableViewCell
        /// En parametre elle prend le model d'un film
        cell.configure(with: movieModel, at: indexPath.row, isLandscape: self.isLandscape)
        return cell
    }
        /// Function ViewImage qui hérit
    @objc func viewImage(_ sender: AnyObject) {
        /// tag identifie les objets de vue dans votre application.
        let tag = sender.view.tag
        /// L'idTag variable que nous avons crée plus haut, on y stock le tag de la vue
        idTag = tag
        /// On spécifie dans cette fonction  que l'identifiant du segue est SearchToInfo
        performSegue(withIdentifier: "SearchToInfo", sender: self)
    }
        /// On utilise la fonction prepare  pour partager les données d'un controller à un autre
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Si l'identifiant du segue est vérifié
        if segue.identifier == "SearchToInfo" {
            /// a verif
            let destinationVC = segue.destination as! InfoViewController
            destinationVC.id = movieModel[idTag!].id
        }
    }
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var numberRows: Int
    /// Si le landscape est vérifié
        if isLandscape {
            /// Nombres de de films  est égale au nombre de base -1
            numberRows = movieModel.count/6-1
        } else {
            ///  Sinon Nombres de de films  est égale au nombre de base -1
            numberRows = movieModel.count/3-1
        }
        /// Si l'index de l'objet recue est égale au nombre de lignes
        if indexPath.row == numberRows {
            /// On lance la fonction loadMore pour charger d'avantage de pages
            loadMore()
        }
    }
    // MARK: - LoadMore
    /// La prochaine page, de base à 1
    private var nextPage = 1
    /// La premiere page, de base à 1 aussi
    private var currentPage = 1
    /// Fonction pour charger d'avantage de pages
    func loadMore() {
        if let modelPage = movieModel.last?.currentPage, let totalPages = movieModel.last?.totalPages {
            currentPage = modelPage
            /// si le dernier élement de la collection currentPage est inférieur au nombre total de pages
            if modelPage < totalPages {
                /// On ajoute à la prochaine page le calcul currentPage + 1
                nextPage = currentPage + 1
                /// On effectue la fonction fetchMovies pour recharger les films
                movieManager.fetchMovies(page: nextPage, sort: filterMethod, query: query) {result in
                    switch result {
                    case .success(let movies):
                        self.didUpdateMovie(self.movieManager, movie: movies)
                    case .failure(let error):
                        self.didFailWithError(error: error)
                    }
                }
            }
            /// Sinon ...
        } else {
            /// On recharge quand meme les films
            movieManager.fetchMovies(page: nextPage, sort: filterMethod, query: query) {result in
                switch result {
                case .success(let movies):
                    self.didUpdateMovie(self.movieManager, movie: movies)
                case .failure(let error):
                    self.didFailWithError(error: error)
                }
            }
          }
       }
    }

// MARK: - MovieManagerDelegate
/// Extension pour gérer la file du SearchViewController qui hérite du délégué MovieManager
extension SearchViewController {
    /// Fonction pour mettre à jour un film
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        /// Dans la queue principale on gère l'asynchrone ici
        DispatchQueue.main.async {
            /// Pour chaque fiilm
            for index in movie {
                /// On applique un film à un model de film
                self.movieModel.append(index)
            }
            /// Puis on recharge les données de la table view
            self.tableView.reloadData()
        }
    }
    /// Fonction d'alerte asynchrone d'erreur
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { _ in }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        print("erreur\(error)")
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    /// Fonction de recherche de films
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /// Si le texte tapé par l'utilisateur est vérifié
        if let searchText = searchBar.text {
            /// On designe le model comme un tableau vide
            self.movieModel = []
            /// on recharge la tableview
            self.tableView.reloadData()
            /// On insere la propriété de l'endpoint pour effectuer la recherche
            self.query = "&query=\(searchText.replacingOccurrences(of: " ", with: "%20"))"
            searchBar.resignFirstResponder()
            loadMore()
        }
    }
}
