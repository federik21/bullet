//
//  Center.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//

class Bag {
    private var bullets: [Bullet]

    init(bullets: [Bullet]) {
        self.bullets = bullets.shuffled()
    }

    func addBullet(_ bullet: Bullet) {
        self.bullets.append(bullet)
    }

    func drawBullet() -> Bullet? {
        guard bullets.count > 0 else {
            return nil
        }
        bullets.shuffle()
        let bullet = bullets.first
        bullets.removeFirst()
        return bullet
    }
}

struct GameComponents {
    struct Bullets {
        static let center: [Bullet] = {
            var bag = [Bullet]()
            let colors: [Bullet.TokenType] = [.red, .blue, .green, .yellow, .pink ]
            for color in colors {
                bag +=  Array(repeating: Bullet(color: color, value: 4), count: 2)
                bag +=  Array(repeating: Bullet(color: color, value: 3), count: 6)
                bag +=  Array(repeating: Bullet(color: color, value: 2), count: 6)
                bag +=  Array(repeating: Bullet(color: color, value: 1), count: 6)

                bag +=  Array(repeating: Bullet(color: color, value: 4, star: true), count: 2)
                bag +=  Array(repeating: Bullet(color: color, value: 3, star: true), count: 2)
                bag +=  Array(repeating: Bullet(color: color, value: 2, star: true), count: 2)
                bag +=  Array(repeating: Bullet(color: color, value: 1, star: true), count: 2)
            }
            return bag
        }()
    }
}
