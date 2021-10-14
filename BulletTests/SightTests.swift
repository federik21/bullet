//
//  SightTests.swift
//  BulletTests
//
//  Created by Piccirilli Federico on 10/5/21.
//

import XCTest
import Combine
@testable import Bullet

class SightTests: XCTestCase {

    var sight: Sight = Sight(rows: 5, columns: 5)
    var cancellables: [AnyCancellable] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInsert() throws {
        let firstBullet = Bullet(color: .blue, value: 1, star: false)
        let secondBullet = Bullet(color: .blue, value: 4, star: false)
        sight.insert(bullet: firstBullet).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: {result in
            XCTAssertTrue(result.col == 1)
            XCTAssertTrue(result.row == 0)
        }).store(in: &cancellables)
        sight.insert(bullet: secondBullet).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: {result in
            XCTAssertTrue(result.col == 1)
            XCTAssertTrue(result.row == 4)
        }).store(in: &cancellables)
    }

    func testPattern() throws {
        let firstBullet = Bullet(color: .red, value: 1, star: false)
        sight.insert(bullet: firstBullet).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: {result in
            XCTAssertTrue(result.col == 0)
            XCTAssertTrue(result.row == 0)
        }).store(in: &cancellables)
        sight.moveBulletInCoordinates((0,0), direction: .right).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: {result in
            XCTAssertTrue(result.col == 2)
            XCTAssertTrue(result.row == 0)
        }).store(in: &cancellables)

        sight.insert(bullet: firstBullet).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: {result in
            XCTAssertTrue(result.col == 0)
            XCTAssertTrue(result.row == 0)
        }).store(in: &cancellables)

        sight.applyPattern(EsfirPattern.first, from: (0,0)).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: { result in
            print(result)
        }).store(in: &cancellables)
    }
}
