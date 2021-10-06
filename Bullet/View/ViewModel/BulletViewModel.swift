//
//  BulletViewModel.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/5/21.
//

import UIKit

struct BulletViewModel {
    let row: Int
    let col: Int
    let value: String
    let star: Bool
    let color: UIColor

    init(bulletResult: BulletResult) {
        self.row = bulletResult.row
        self.col = bulletResult.col
        self.value = "\(bulletResult.bullet.value)"
        self.star = bulletResult.bullet.star
        switch bulletResult.bullet.color {
        case .red:
            self.color = .red
        case .blue:
            self.color = .blue
        case .green:
            self.color = .green
        case .yellow:
            self.color = .yellow
        case .pink:
            self.color = .systemPink
        }
    }

    init(row: Int, col: Int, value: String, star: Bool, color: Bullet.TokenType) {
        self.row = row
        self.col = col
        self.value = value
        self.star = star
        switch color {
        case .red:
            self.color = .red
        case .blue:
            self.color = .blue
        case .green:
            self.color = .green
        case .yellow:
            self.color = .yellow
        case .pink:
            self.color = .systemPink
        }
    }
}
