//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Hongze Xia on 17/4/20.
//  Copyright © 2020 Hongze Xia. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GameOfLifeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWorldFlip() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let world = World(20, 20)
        world.randomize(0.5)
        let s1010 = world.getState(10, 10)
        world.flipState(10, 10)
        XCTAssertTrue(s1010 == !world.getState(10, 10))
        let s1515 = world.getState(15, 15)
        let s1617 = world.getState(16, 17)
        world.flipState(at: [(15, 15), (16, 17)])
        XCTAssertFalse(s1515 == world.getState(15, 15))
        XCTAssertNotEqual(s1617, world.getState(16, 17))
    }

    func testWorldStep() throws {
        let world = World(20, 20)
        world.randomize(0.5)
        for _ in 0..<5 {
            var diff = world.step()
            var diffNew = world.stepNew()
            diff.sort(by: { a, b in (a.0 < b.0 || (a.0 == b.0 && a.1 < b.1)) })
            diffNew.sort(by: { a, b in (a.0 < b.0 || (a.0 == b.0 && a.1 < b.1)) })
            XCTAssertEqual(diff.count, diffNew.count)
            for i in 0..<diff.count {
                XCTAssertEqual(diff[i].0, diffNew[i].0)
                XCTAssertEqual(diff[i].1, diffNew[i].1)
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
