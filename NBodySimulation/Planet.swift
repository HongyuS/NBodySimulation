import Foundation

public struct Planet: Identifiable {
    // Physics parameters of the planet
    public var xxPos: Double
    public var yyPos: Double
    public var xxVel: Double
    public var yyVel: Double
    public let mass: Double
    // Name and unique ID of the planet object
    public let planetName: String
    public var id: UUID
    /// Standard initializer to create a new `Planet` object.
    public init(xP: Double, yP: Double, xV: Double, yV: Double, m: Double, name: String) {
        xxPos = xP; yyPos = yP
        xxVel = xV; yyVel = yV
        mass = m
        planetName = name
        id = UUID()
    }
    /// Copy a `Planet` object.
    public init(p: Planet) {
        xxPos = p.xxPos; yyPos = p.yyPos
        xxVel = p.xxVel; yyVel = p.yyVel
        mass = p.mass
        planetName = p.planetName
        id = p.id
    }
}

extension Planet: Equatable {
    public static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Force Calculations
extension Planet {
    /// A method calculates the square of distance between two Planets.
    /// - Parameter p: the other `Planet`
    /// - Returns: the square of distance between two Planets
    private func squareOfDistance(between p: Planet) -> Double {
        pow((xxPos - p.xxPos), 2) + pow((yyPos - p.yyPos), 2)
    }
    
    /// A method calculates the distance between two Planets.
    /// - Parameter p: the other `Planet`
    /// - Returns: the distance between two Planets
    public func distance(between planet: Planet) -> Double {
        squareOfDistance(between: planet).squareRoot()
    }
    
    /// A method calculates the magnitude of the force exerted by another Planet.
    /// - Parameter p: the other `Planet`
    /// - Returns: the magnitude of the force
    public func force(exertedBy planet: Planet) -> Double {
        .G * mass * planet.mass / squareOfDistance(between: planet)
    }
    
    public func forceX(exertedBy planet: Planet) -> Double {
        let F = force(exertedBy: planet)
        let dx = planet.xxPos - xxPos
        let r = distance(between: planet)
        return F * dx / r
    }
    
    public func forceY(exertedBy planet: Planet) -> Double {
        let F = force(exertedBy: planet)
        let dy = planet.yyPos - yyPos
        let r = distance(between: planet)
        return F * dy / r
    }
    
    public func netForceX(by planets: [Planet]) -> Double {
        let neighbours = planets.filter({ $0 != self })
        return neighbours.map {forceX(exertedBy: $0)} .reduce(0, +)
    }
    
    public func netForceY(by planets: [Planet]) -> Double {
        let neighbours = planets.filter({ $0 != self })
        return neighbours.map {forceY(exertedBy: $0)} .reduce(0, +)
    }
}

// MARK: - Update Position with Force
extension Planet {
    /// A method that determines how much the forces exerted on the planet will
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

