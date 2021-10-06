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
            while remainingSteps > 0 && currentRow < self.columns {
                if self[currentRow, column] == nil {
                    remainingSteps -= 1
                }
                currentRow += 1
            }
            guard currentRow < self.columns else {
                return 🔮(.failure(SightError.playerHit))
            }
            self[currentRow - 1,column] = bullet
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
}

enum SightError: Error{
    case unSpawnableException, genericError, playerHit
}

struct BulletResult {
    var row: Int
    var col: Int
    var bullet: Bullet
}
