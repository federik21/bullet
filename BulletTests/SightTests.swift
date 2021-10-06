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
        sight.insert(bullet: firstBullet).sink(receiveCompletion: { _ in
            print("completed")
        },
        receiveValue: {result in
            print("inserted at depth: \(result.row + 1)")
        }).store(in: &cancellables)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
