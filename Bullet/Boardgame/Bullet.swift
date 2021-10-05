//
//  Bullet.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//

enum BulletError: Error {
    case WrongValueInit
}

struct Bullet {
    enum TokenType {
        case red, blue, green, yellow, pink
    }
    
    var color: TokenType
    var value: Int
    var star: Bool

    init(color: TokenType, value: Int, star: Bool ) {
        assert(value >= 0 && value <= 5, "Malformed Token")
        self.value = value
        self.color = color
        self.star = star
    }
}
