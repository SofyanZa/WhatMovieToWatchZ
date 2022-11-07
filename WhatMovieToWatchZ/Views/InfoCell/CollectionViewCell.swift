//
//  CollectionViewCell.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import UIKit

/// Collection view cellule configuration d'un acteur
class CollectionViewCell: UICollectionViewCell {

    /// On a besoin d'une image pour representer l'acteur visuellement
    @IBOutlet var castImage: UIImageView!
    /// Le nom de l'acteur
    @IBOutlet weak var castLabel: UILabel!

    /// L'identifiant de la collectionView
    static let identifier = "CollectionViewCell"

    /// Le fichier nib
    static func nib() -> UINib {
        return UINib(nibName: "CollectionViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /// Creation d'une fonction de configuration avec le model de donnée crée de CastModel
    public func configure(with model: CastModel) {
        castImage.image = model.castImage
        castLabel.text = model.castName
    }
}
