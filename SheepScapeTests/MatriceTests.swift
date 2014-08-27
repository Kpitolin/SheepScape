//
//  MatriceTests.swift
//  SheepScape
//
//  Created by KEVIN on 26/08/2014.
//  Copyright (c) 2014 KEVIN. All rights reserved.
//

import UIKit
import XCTest

class MatriceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    func testMatriceSplit() {
        // This is an example of a functional test case.
        var matrice : Array = [[String()]]
        for i in 1...10
        {
            var line : Array = [String()]
            for j in 1...5
            {
                line.append("0")
            }
            matrice.append(line)
        }
        
        let array = Level.splitMatrice(matrice)
        
        XCTAssertNil(array, "matrice can't be nil")
        XCTAssertNotEqual(array.count,1, "matrice incorrect")
        
//        for var m : Array in matrice[0] {
//            XCTAssertNotEqual(m.count,REGULAR_LINE_COUNT, "line incorrect")
//
//        }
        

    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
