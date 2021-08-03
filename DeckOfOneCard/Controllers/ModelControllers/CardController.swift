//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by Kyle Warren on 8/3/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import Foundation
import UIKit

class CardController {
    
    // https://deckofcardsapi.com/api/deck/new/draw/?count=1
    // 1 - Prepare URL
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw")
    //static let cardComponent = "draw"
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
        
        // 2 - Contact server
        guard let url = baseURL else { return (completion(.failure(.invalidURL))) }
        //let cardURL = baseURL.appendingPathComponent(cardComponent)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false) // putting query url together
        
        let query = URLQueryItem(name: "count", value: "1") // key and value for query
        
        components?.queryItems = [query] // components and query
        
        guard let finalURL = components?.url else { return } //components and query added to url for finalURL
        
        print(finalURL) // debug print to see final URL
        
        // 3 - Handle errors from the server
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        // 4 - Check for json data
            guard let data = data else { return completion(.failure(.noData)) }
        // 5 - Decode json into a Card
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else { return }
                return completion(.success(card))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
       
        // 1 - Prepare URL
        guard let url = card.image else { return completion(.failure(.invalidURL)) }
        // 2 - Contact server
        URLSession.shared.dataTask(with: url) { data, _, error in
        // 3 - Handle errors from the server
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        // 4 - Check for image data
            guard let data = data else { return completion(.failure(.noData))}
        // 5 - Initialize an image from the data
            guard let image = UIImage(data: data) else { return completion(.failure(.unableToDecode))}
            return completion(.success(image))
        
        }.resume()
    }
} // End of Class
