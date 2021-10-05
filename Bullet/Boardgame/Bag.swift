//
//  Center.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//

struct Bag {
    private var bullets: [Bullet]

    init(bullets: [Bullet]) {
        self.bullets = bullets.shuffled()
    }

    mutating func addBullet(_ bullet: Bullet) {
        self.bullets.append(bullet)
    }

    mutating func drawBullet() -> Bullet? {
        guard bullets.count > 0 else {
            return nil
        }
        bullets.shuffle()
        let bullet = bullets.first
        bullets.removeFirst()
        return bullet
    }
}

struct  GameComponents {
    struct Bullets {
        static let center: [Bullet] = [
            Bullet(color: .red, value: 4),
            Bullet(color: .red, value: 3),
            Bullet(color: .red, value: 2),
            Bullet(color: .red, value: 1),

            Bullet(color: .blue, value: 4),
            Bullet(color: .blue, value: 3),
            Bullet(color: .blue, value: 2),
            Bullet(color: .blue, value: 1),

            Bullet(color: .green, value: 4),
            Bullet(color: .green, value: 3),
            Bullet(color: .green, value: 2),
            Bullet(color: .green, value: 1),

            Bullet(color: .yellow, value: 4),
            Bullet(color: .yellow, value: 3),
            Bullet(color: .yellow, value: 2),
            Bullet(color: .yellow, value: 1),

            Bullet(color: .pink, value: 4),
            Bullet(color: .pink, value: 3),
            Bullet(color: .pink, value: 2),
            Bullet(color: .pink, value: 1),
        ]
    }

}
