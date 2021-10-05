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
        case red, blue, yellow, green, pink
    }
    
    var color: TokenType
    var value: Int

    init(color: TokenType, value: Int ) throws {
        guard value >= 1 && value <= 5 else {
            throw BulletError.WrongValueInit
        }
        self.value = value
        self.color = color
    }
}
