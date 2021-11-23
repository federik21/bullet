//
//  Pattern.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/6/21.
//

struct PatternSpaceRequirement {
    var bulletType: Bullet.TokenType?
    var value: Int?
    var starred: Bool?
    var clearAtEnd: Bool
    var mustBeEmpty: Bool

    init(bulletType: Bullet.TokenType? = nil, value: Int? = nil, starred: Bool? = nil, clearAtEnd: Bool = false, mustBeEmpty: Bool = false) {
        self.bulletType = bulletType
        self.value = value
        self.starred = starred
        self.clearAtEnd = clearAtEnd
        self.mustBeEmpty = mustBeEmpty
    }
}

protocol Pattern {
    var area: Board<PatternSpaceRequirement> { get }
}

extension Bullet {
    func isKindOf(patternSpace: PatternSpaceRequirement) -> Bool {
        var isValid = true
        if let patternColor = pattern.bulletType {
            isValid = patternColor == self.color
        }
        if let patternValue = pattern.value {
            isValid = patternValue == self.value
        }
        if let patternStar = pattern.starred {
            isValid = patternStar == self.star
        }
        return isValid
    }
}
