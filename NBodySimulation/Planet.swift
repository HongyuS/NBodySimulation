//
//  Planet.swift
//  NBodySimulation
//
//  Created by Hongyu Shi on 2022/6/10.
//

import Foundation
import RegexBuilder

/// A planet with position and velocity.
public struct Planet: Identifiable {
    // Physics parameters of the planet
    var xxPos: Double
    var yyPos: Double
    var xxVel: Double
    var yyVel: Double
    let mass: Double
    // Name and unique ID of the planet object
    public let name: String
    public var id: UUID
    /// Standard initializer to create a new planet.
    public init(xP: Double, yP: Double, xV: Double, yV: Double,
                m: Double, name: String) {
        xxPos = xP; yyPos = yP
        xxVel = xV; yyVel = yV
        mass = m
        self.name = name
        id = UUID()
    }
    /// Copy from an existing planet.
    public init(p: Planet) {
        xxPos = p.xxPos; yyPos = p.yyPos
        xxVel = p.xxVel; yyVel = p.yyVel
        mass = p.mass
        name = p.name
        id = p.id
    }
}

extension Planet: Equatable {
    /// Check equal by planets' IDs.
    public static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Force Calculations
extension Planet {
    /// Calculate the square of distance between two planets.
    /// - Parameter p: the other planet
    /// - Returns: the square of distance between two Planets
    private func squareOfDistance(between p: Planet) -> Double {
        pow((xxPos - p.xxPos), 2) + pow((yyPos - p.yyPos), 2)
    }
    
    /// Calculate the distance between two planets.
    /// - Parameter p: the other planet
    /// - Returns: the distance between two Planets
    func distance(between planet: Planet) -> Double {
        squareOfDistance(between: planet).squareRoot()
    }
    
    /// Calculate the magnitude of the force exerted by another planet.
    /// - Parameter p: the other planet
    /// - Returns: the magnitude of the force
    private func force(exertedBy planet: Planet) -> Double {
        .G * mass * planet.mass / squareOfDistance(between: planet)
    }
    
    /// Calculate the force exerted by another planet along X axis.
    /// - Parameter planet: the other planet
    /// - Returns: the force along X axis
    func forceX(exertedBy planet: Planet) -> Double {
        let F = force(exertedBy: planet)
        let dx = planet.xxPos - xxPos
        let r = distance(between: planet)
        return F * dx / r
    }
    
    /// Calculate the force exerted by another planet along Y axis.
    /// - Parameter planet: the other planet
    /// - Returns: the force along Y axis
    func forceY(exertedBy planet: Planet) -> Double {
        let F = force(exertedBy: planet)
        let dy = planet.yyPos - yyPos
        let r = distance(between: planet)
        return F * dy / r
    }
    
    /// Calculate the net force exerted by other planets along X axis.
    /// - Parameter planets: an array of other planets
    /// - Returns: net force along X axis
    func netForceX(by planets: [Planet]) -> Double {
        let neighbours = planets.filter({ $0 != self })
        return neighbours.map {forceX(exertedBy: $0)} .reduce(0, +)
    }
    
    /// Calculate the net force exerted by other planets along Y axis.
    /// - Parameter planets: an array of other planets
    /// - Returns: net force along Y axis
    func netForceY(by planets: [Planet]) -> Double {
        let neighbours = planets.filter({ $0 != self })
        return neighbours.map {forceY(exertedBy: $0)} .reduce(0, +)
    }
}

// MARK: - Update Position with Force
extension Planet {
    /// Update a planet's position and velosity, given the net force and time.
    ///
    /// This method determines how much the forces exerted on the planet will
    /// cause that planet to accelerate, and the resulting change in the planet’s
    /// velocity and position in a small period of time `dt`.
    /// - Parameters:
    ///   - dt: a small period of time
    ///   - fX: net force along X direction
    ///   - fY: net force along Y direction
    public mutating func update(netForceX fX: Double, netForceY fY: Double, dt: Double) {
        let aX = fX / mass
        let aY = fY / mass
        xxVel += aX * dt
        yyVel += aY * dt
        xxPos += xxVel * dt
        yyPos += yyVel * dt
    }
}

// MARK: - Special Initializer
extension Planet {
    /// Initialize a planet from a string.
    ///
    /// The initializer uses Swift Regex to match the pattern.
    /// - Parameter text: String text that describes the parameters of a planet.
    public init?(_ text: String) {
        let value = /[+|-]?(?:\d+)(?:\.\d+)?(?:[eE][+|-]?\d+)?/
        let separator = /\s+|\t/
        let matcher = Regex {
            Optionally { separator }
            Capture { value } // xxPos
            separator
            Capture { value } // yyPos
            separator
            Capture { value } // xxVel
            separator
            Capture { value } // yyVel
            separator
            Capture { value } // mass
            separator
            Capture { OneOrMore {.word} } // name
        }
        guard let match = text.prefixMatch(of: matcher) else { return nil }
        self.xxPos = Double(match.1)!
        self.yyPos = Double(match.2)!
        self.xxVel = Double(match.3)!
        self.yyVel = Double(match.4)!
        self.mass = Double(match.5)!
        self.name = String(match.6)
        self.id = UUID()
    }
}
