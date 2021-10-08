//
//  EsfirPattern.swift
//  Bullet
//
//  Created by Piccirilli Federico on 10/6/21.
//

enum EsfirPattern {
    static let fireRage: Pattern = EsfirPattern1()
}

// rxr
// ***
struct EsfirPattern1: Pattern {
    var area: Board<PatternSpaceRequirement> = {
        let area = Board<PatternSpaceRequirement>(rows: 2, columns: 3)
        area[0,0] = PatternSpaceRequirement(bulletType: .red,
                                            value: nil,
                                            starred: nil,
                                            clearAtEnd: false,
                                            mustBeEmpty: false)
        area[1,0] = PatternSpaceRequirement(bulletType: .red,
                                            value: nil,
                                            starred: nil,
                                            clearAtEnd: false,
                                            mustBeEmpty: false)
        area[2,0] = PatternSpaceRequirement(bulletType: nil,
                                            value: nil,
                                            starred: nil,
                                            clearAtEnd: false,
                                            mustBeEmpty: true)
        area[1,0] = PatternSpaceRequirement(bulletType: .red,
                                            value: nil,
                                            starred: nil,
                                            clearAtEnd: true,
                                            mustBeEmpty: false)
        area[1,1] = PatternSpaceRequirement(bulletType: nil,
                                            value: nil,
                                            starred: nil,
                                            clearAtEnd: true,
                                            mustBeEmpty: false)
        area[1,2] = PatternSpaceRequirement(bulletType: nil,
                                            value: nil,
                                            starred: nil,
                                            clearAtEnd: true,
                                            mustBeEmpty: false)
        return area
    }()

}
