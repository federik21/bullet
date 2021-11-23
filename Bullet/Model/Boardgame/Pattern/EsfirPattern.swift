//
//  EsfirPattern.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/6/21.
//

enum CharacterPatterns {
    static let esfir: [Pattern] = [EsfirPattern1(), EsfirPattern2(), EsfirPattern3()]
}

// rxr
// ***
fileprivate struct EsfirPattern1: Pattern {
    var area: Board<PatternSpaceRequirement> = {
        let area = Board<PatternSpaceRequirement>(rows: 2, columns: 3)
        area[0,0] = PatternSpaceRequirement(bulletType: .red)
        area[1,0] = PatternSpaceRequirement(mustBeEmpty: true)
        area[2,0] = PatternSpaceRequirement(bulletType: .red)

        area[1,0] = PatternSpaceRequirement(clearAtEnd: true)
        area[1,1] = PatternSpaceRequirement(clearAtEnd: true)
        area[1,2] = PatternSpaceRequirement(clearAtEnd: true)
        return area
    }()
}

// *--
// *a-
// *aa
fileprivate struct EsfirPattern2: Pattern {
    var area: Board<PatternSpaceRequirement> = {
        let area = Board<PatternSpaceRequirement>(rows: 3, columns: 3)
        area[0,0] = PatternSpaceRequirement(clearAtEnd: true)

        area[1,0] = PatternSpaceRequirement(clearAtEnd: true)
        area[1,1] = PatternSpaceRequirement(mustBeEmpty: false)

        area[2,0] = PatternSpaceRequirement(clearAtEnd: true)
        area[2,1] = PatternSpaceRequirement(mustBeEmpty: false)
        area[2,2] = PatternSpaceRequirement(mustBeEmpty: false)
        return area
    }()
}


// axa
// -*-
// *-*
fileprivate struct EsfirPattern3: Pattern {
    var area: Board<PatternSpaceRequirement> = {
        let area = Board<PatternSpaceRequirement>(rows: 3, columns: 3)
        area[0,0] = PatternSpaceRequirement(mustBeEmpty: false)
        area[1,0] = PatternSpaceRequirement(mustBeEmpty: true)
        area[2,0] = PatternSpaceRequirement(mustBeEmpty: false)

        area[1,1] = PatternSpaceRequirement(clearAtEnd: true)
        area[2,0] = PatternSpaceRequirement(clearAtEnd: true)
        area[2,2] = PatternSpaceRequirement(clearAtEnd: true)
        return area
    }()
}
