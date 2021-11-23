//
//  Player.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//

protocol Player {
    var bag: Bag { get set }
    var sight: Sight { get set }
    var lives: Int { get set}
    var patterns: [Pattern] { get set }
    var handOfCards: [Pattern] { get set }
}
