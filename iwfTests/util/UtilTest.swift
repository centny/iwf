//
//  UtilTest.swift
//  iwf
//
//  Created by Centny on 8/24/15.
//  Copyright (c) 2015 Snows. All rights reserved.
//

import UIKit
import XCTest
import iwf

class UtilTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testReadf() {
        var res = Util.writef_("/xd/t.txt", str:"abc")
        XCTAssert(res, "writer error")
        var a = Util.readf_("/ss/t.xt")
        println(a)
        var b = Util.readf_("/xd/t.txt")
        if b==nil{
            XCTAssert(false, "data is nil")
        }else{
            let x:String=b!
            println(x)
        }
    }

}
