//
//  Player.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//
import Combine

class Player {
    var bag: Bag
    var sight: Sight = Sight(rows: 6, columns: 6)
    var lives: Int = 4

    init(center: Bag) {
        var pulledBullets: [Bullet] = []
        for _ in 0...10 {
            guard let drawBullet = center.drawBullet() else {
                fatalError("Not enought bullet in center!")
            }
            pulledBullets.append(drawBullet)
        }
        self.bag = Bag(bullets: pulledBullets)
    }
}
