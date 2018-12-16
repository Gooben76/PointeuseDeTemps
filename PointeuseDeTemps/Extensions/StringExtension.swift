//
//  StringExtension.swift
//  PointeuseDeTemps
//
//  Created by Benoît Goossens on 09/12/2018.
//  Copyright © 2018 Benoît Goossens. All rights reserved.
//

import UIKit

extension String {
    
    func hauteur(largeur: CGFloat, font: UIFont) -> CGFloat {
        let taille = CGSize(width: largeur, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: taille, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }
    
    func largeur(hauteur: CGFloat, font: UIFont) -> CGFloat {
        let taille = CGSize(width: .greatestFiniteMagnitude, height: hauteur)
        let rect = self.boundingRect(with: taille, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
    
    func largeur(largeur: CGFloat, font: UIFont) -> CGFloat {
        let taille = CGSize(width: largeur, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(with: taille, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
}
