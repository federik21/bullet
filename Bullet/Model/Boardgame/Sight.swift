//
//  Scene.swift
//  FantasticHero
//
//  Created by Piccirilli Federico on 20/07/21.
//

/*
 All the positions Could be occupied by a bullet.
 In a bidimentional array, the positions are accessed in a C-like pointer arithmetics.
 For instance, a N*M array is something like this
 (0,0) (0,1) (0,2) (0,3) (0,4) ... (0,m-1)
 (1,0) (1,1) (1,2) (1,3) (1,4) ... (1,m-1)
..........................................
 (n-1,0).........................(n-1,m-1)
*/

import Combine

class Board<T>{
    private var positions: [T?]

//   Rows and columns should be changed according to the shared model
    let rows: Int
    let columns: Int

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        positions = Array(repeating: nil, count: rows * columns)
    }

    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    subscript(row: Int, column: Int) -> T? {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return positions[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            positions[(row * columns) + column] = newValue
        }
    }

    func getRowFromIndex(index: Int) -> Int {
        return index / rows
    }

    func getColumnFromIndex(index: Int) -> Int {
        return index % columns
    }
}

class Sight: Board<Bullet> {
    func insert(bullet: Bullet) -> Future<BulletResult, Error> {
        print("Inserting \(bullet)")
        return Future<BulletResult, Error> { [weak self] 🔮 in
            guard let self = self else {
                return 🔮(.failure(SightError.genericError))
            }
            let column = self.columnFromBullet(bullet)
            var remainingSteps = bullet.value
            var currentRow = 0
            while remainingSteps > 0 && currentRow < self.rows {
                if self[currentRow, column] == nil {
                    remainingSteps -= 1
                }
                currentRow += 1
            }
            guard remainingSteps == 0 else {
                return 🔮(.failure(SightError.playerHit))
            }
            self[currentRow - 1, column] = bullet
            return 🔮(.success(BulletResult(row: currentRow - 1, col: column, bullet: bullet)))
        }
    }

    func clear(row: Int, col: Int) {
        self[row,col] = nil
    }

    private func columnFromBullet(_ bullet: Bullet) -> Int {
        switch bullet.color {
        case .red:
            return 0
        case .blue:
            return 1
        case .green:
            return 2
        case .yellow:
            return 3
        case .pink:
            return 4
        }
    }
    // MARK: PATTERNS
    //Coordinates refers to the top-left vertex of the pattern
    func applyPattern(_ pattern: Pattern, from coordinates: (Int,Int)) -> Future<[(Int,Int)], Error> {
        let tX = coordinates.0
        let tY = coordinates.1
        var patternX = 0
        var patternY = 0
        return Future<[(Int,Int)], Error> { [weak self] 🔮 in
            guard let self = self else {
                return 🔮(.failure(SightError.genericError))
            }
            var spacesToBeCleared: [(Int,Int)] = []
            guard (tX + pattern.area.rows) < self.rows && (tY + pattern.area.columns) < self.columns else {
                return 🔮(.failure(PatternError.patternOutOfBounds))

            }
            for row in tX...(tX + pattern.area.rows)  {
                for col in tY...(tY + pattern.area.columns) {
                    // if no requirement is present, go on
                    guard let requirement = pattern.area[patternX,patternY] else {
                        continue
                    }
                    // if there is a bullet, but there must NOT be a bullet per requisite, break immediately
                    guard let currentBullet = self[row,col], !requirement.mustBeEmpty else {
                        return 🔮(.failure(PatternError.patternNotAppliable))
                    }
                    guard currentBullet.isKindOf(patternSpace: requirement) else {
                        return 🔮(.failure(PatternError.patternNotAppliable))
                    }
                    if requirement.clearAtEnd {
                        spacesToBeCleared.append((row,col))
                    }
                    patternY += 1
                }
                patternX += 1
            }
            for space in spacesToBeCleared {
                self.clear(row: space.0, col: space.1)
            }
            return 🔮(.success(spacesToBeCleared))
        }
    }

    // MARK: POWERS
    // returns a future with the new position of the bullet
    func moveBulletInCoordinates(_ coordinates: (Int,Int), direction: OrthogonalMovementDirection) -> Future<BulletResult, Error> {
        return Future<BulletResult, Error> { [weak self] 🔮 in
            guard let self = self else {
                return 🔮(.failure(SightError.genericError))
            }
            guard let bullet = self[coordinates.0, coordinates.1] else {
                return 🔮(.failure(SightError.genericError))
            }
            guard self.canMove(coordinates, direction: direction) else {
                return 🔮(.failure(SightError.genericError))
            }
            var newCoordinateX: Int = coordinates.0
            var newCoordinateY: Int = coordinates.1
            switch direction {
            case .up:
                newCoordinateY -= 1
                while newCoordinateY > 0 && self[newCoordinateX,newCoordinateY] != nil {
                    newCoordinateY -= 1
                }
            case .down:
                newCoordinateY += 1
                while newCoordinateY < self.rows && self[newCoordinateX,newCoordinateY] != nil {
                    newCoordinateY += 1
                }
            case .right:
                newCoordinateX += 1
                while newCoordinateX < self.columns && self[newCoordinateX,newCoordinateY] != nil {
                    newCoordinateX += 1
                }
            case .left:
                newCoordinateX -= 1
                while newCoordinateX > 0 && self[newCoordinateX,newCoordinateY] != nil {
                    newCoordinateX -= 1
                }
            }
            self[coordinates.0, coordinates.1] = nil
            self[newCoordinateX, newCoordinateY] = bullet
            return 🔮(.success(BulletResult(row: newCoordinateY, col: newCoordinateX, bullet: bullet)))
        }
    }

    func canMove(_ coordinates: (Int,Int), direction: OrthogonalMovementDirection) -> Bool {
        // Check if the new index is valid, is not occupied, and is on the same row/column
        switch direction {
        case .up:
            let newCoordinates = (x: coordinates.0 - 1,
                                  y: coordinates.1)
            return indexIsValid(row: newCoordinates.x,
                               column: newCoordinates.y) &&
                  self[newCoordinates.x, newCoordinates.y] == nil &&
                  newCoordinates.y == coordinates.1
        case .down:
            let newCoordinates = (x: coordinates.0 + 1,
                                  y: coordinates.1)
            return indexIsValid(row: newCoordinates.x,
                               column: newCoordinates.y) &&
                  self[newCoordinates.x, newCoordinates.y] == nil &&
                  newCoordinates.y == coordinates.1
        case .right:
            let newCoordinates = (x: coordinates.0,
                                  y: coordinates.1 + 1)
            return indexIsValid(row: newCoordinates.x,
                               column: newCoordinates.y) &&
                  self[newCoordinates.x, newCoordinates.y] == nil &&
                  newCoordinates.x == coordinates.0
        case .left:
            let newCoordinates = (x: coordinates.0,
                                  y: coordinates.1 - 1)
            return indexIsValid(row: newCoordinates.x,
                               column: newCoordinates.y) &&
                  self[newCoordinates.x, newCoordinates.y] == nil &&
                  newCoordinates.x == coordinates.0
        }
    }
}

enum SightError: Error{
    case unSpawnableException, genericError, playerHit
}

enum PatternError: Error{
    case patternOutOfBounds, patternNotAppliable
}

enum OrthogonalMovementDirection {
    case up, down, right, left
}

struct BulletResult {
    var row: Int
    var col: Int
    var bullet: Bullet
}
