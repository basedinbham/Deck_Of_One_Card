//
//  Card.swift
//  DeckOfOneCard
//
//  Created by Kyle Warren on 8/3/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation

struct TopLevelObject: Decodable {
    var cards: [Card]

} //End of struct

struct Card: Decodable {
    let value: String
    let suit: String
    let image: URL?
    
} //End of struct

