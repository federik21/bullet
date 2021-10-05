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
    let rows: Int = 5
    let columns: Int = 5

    init() {
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
    /// This funcion is called to insert a Bullet in your Sight. If the bullet is allocable, returns success with the row. An error, otherwise (it can be an Hit, too.
    func insert(bullet: Bullet, column: Int) -> Future<Int, Error> {
        return Future<Int, Error> {[weak self] 🔮 in
            guard let self = self else {
                return 🔮(.failure(BulletBoardError.genericError))
            }
            guard column >= 0 && column < self.columns else {
                return 🔮(.failure(BulletBoardError.unSpawnableException))
            }
            var remainingSteps = bullet.value
            var currentRow = 0
            while remainingSteps > 0 || !(currentRow == self.columns) {
                remainingSteps -= 1
                if self[currentRow, column] == nil {
                    currentRow += 1
                }
            }
            guard currentRow < self.columns else {
                return 🔮(.failure(BulletBoardError.playerHit))
            }
            return 🔮(.success(currentRow))
        }
    }

    func clear(row: Int, col: Int) {
        self[row,col] = nil
    }
}

enum BulletBoardError: Error{
    case unSpawnableException, genericError, playerHit
}
