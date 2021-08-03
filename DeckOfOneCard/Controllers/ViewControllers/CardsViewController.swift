//
//  CardsViewController.swift
//  DeckOfOneCard
//
//  Created by Kyle Warren on 8/3/21.
//  Copyright © 2021 Warren. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    //MARK: - OUTLETS
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelViewText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CardController.fetchCard { result in  
            
            DispatchQueue.main.async {
                switch result {
                case .success(let cards):
                    print(cards)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

//MARK: - ACTIONS
    @IBAction func drawCardButtonTapped(_ sender: Any) {
        CardController.fetchCard { [weak self] (result) in

            DispatchQueue.main.async {
                switch result {
                case .success(let card):
                    self?.fetchImageAndUpdateViews(for: card)
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    func fetchImageAndUpdateViews(for card: Card) {
        CardController.fetchImage(for: card) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.labelViewText.text = "\(card.value) of \(card.suit)"
                    self?.imageView.image = image
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
} // End of Class
