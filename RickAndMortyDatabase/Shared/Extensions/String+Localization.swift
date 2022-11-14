//
//  String+localization.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 09/11/2022.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
