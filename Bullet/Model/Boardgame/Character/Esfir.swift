//
//  Esfir.swift
//  Bullet
//
//  Created by federico piccirilli on 23/11/2021.
//

class Esfir: Player {
    var bag: Bag = Bag(bullets: [])
    var sight: Sight = Sight()
    var lives: Int = 4
    var patterns: [Pattern] = CharacterPatterns.esfir
    var handOfCards: [Pattern] = []
}
