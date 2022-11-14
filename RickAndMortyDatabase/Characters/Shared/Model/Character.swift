//
//  Character.swift
//  RickAndMortyDatabase
//
//  Created by Thomas Noury on 08/11/2022.
//

import Foundation

struct Character: Decodable, Equatable {
    var name: String
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "image"
    }
}
