//
//  NBodySimulationTests.swift
//  NBodySimulationTests
//
//  Created by Hongyu Shi on 2022/6/9.
//

import XCTest

final class NBodySimulationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testForce() throws {
        let sun = Planet(xP: 1.0e12, yP: 2.0e11,
                         xV: 0, yV: 0,
                         m: 2.0e30, name: "Sun")
        
        let saturn = Planet(xP: 2.3e12, yP: 9.5e11,
                            xV: 0, yV: 0,
                            m: 6.0e26, name: "Saturn")
        
        assert(sun.distance(between: saturn) == 1500833101980.3635)
        assert(sun.forceX(exertedBy: saturn) == 3.0778909792377346e+22)
        assert(sun.forceY(exertedBy: saturn) == 1.7757063341756159e+22)
    }
    
    func testNetForce() throws {
        let p1 = Planet(xP: 1.0, yP: 1.0, xV: 3.0, yV: 4.0, m: 5.0, name: "p1")
        let p2 = Planet(xP: 2.0, yP: 1.0, xV: 3.0, yV: 4.0, m: 4e11, name: "p2")
        let p3 = Planet(xP: 4.0, yP: 5.0, xV: 3.0, yV: 4.0, m: 5.0, name: "p3")
        let p4 = Planet(xP: 3.0, yP: 2.0, xV: 3.0, yV: 4.0, m: 5.0, name: "p4")
        
        let group1 = [p2, p3, p4]
        assert(p1.netForceX(by: group1).rounded() == 133)
        assert(p1.netForceY(by: group1).rounded() == 0)
        
        let group2 = [p1, p2, p3, p4]
        assert(p1.netForceX(by: group2).rounded() == 133)
        assert(p1.netForceY(by: group2).rounded() == 0)
    }
    
    func testUpdate() throws {
        var p1 = Planet(xP: 1.0, yP: 1.0, xV: 3.0, yV: 4.0, m: 5.0, name: "p1")
        p1.update(netForceX: 1.0, netForceY: -0.5, dt: 2.0)
        assert(p1.xxVel == 3.4)
        assert(p1.yyVel == 3.8)
        assert(p1.xxPos == 7.8)
        assert(p1.yyPos == 8.6)
    }
    
    func testLoadUniverse() async throws {
        let proj0DataURL = URL(filePath: "/Users/hongyushi/Data/Projects/Ber~CS61B/skeleton-sp18/proj0/data/")
        let fileURL = URL(filePath: "entropy-universe.txt",
                          relativeTo: proj0DataURL)
        let universe = await NBodyUniverse(fileURL: fileURL)
        let planetCount: Int = try Int(
            String(contentsOf: fileURL,
                   encoding: .utf8)
            .components(separatedBy: "\n")[0])!
        let radius = universe.radius
        let planets = universe.planets
        assert(radius == 2.50e11)
        assert(planetCount == universe.planetCount)
        assert(planets.first?.xxPos == 2.20e11 && planets.first?.yyPos == 0.000e00)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
