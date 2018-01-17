//
//  DogYearsPerformanceTests.swift
//  DogYearsPerformanceTests
//
//  Created by Johnathan Chen on 1/17/18.
//  Copyright © 2018 Razeware. All rights reserved.
//

import XCTest
@testable import DogYears

class DogYearsPerformanceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMenuLoadPerformance() {
        var menu = Menu()
        self.measure {
            menu.loadDefaultMenu()
        }
    }

    
}
