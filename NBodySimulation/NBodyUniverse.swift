//
//  NBodyUniverse.swift
//  NBodySimulation
//
//  Created by Hongyu Shi on 2022/6/10.
//

import Foundation

class NBodyUniverse: ObservableObject {
    @Published public var radius: Double
    @Published public var planets: [Planet]
    public var planetCount: Int { planets.count }
    
    public init(radius: Double, planets: [Planet]) {
        self.radius = radius
        self.planets = planets
    }
}

extension NBodyUniverse {
    /// Update a planet's position and velosity, given the net force and time.
    /// - Parameter dt: a small period of time
    public func updateUniverse(dt: Double) {
        var xForces: [Double] = []
        var yForces: [Double] = []
        for planet in planets {
            xForces.append(planet.netForceX(by: planets))
            yForces.append(planet.netForceY(by: planets))
        }
        for i in 0 ..< planets.count {
            planets[i].update(netForceX: xForces[i], netForceY: yForces[i], dt: dt)
        }
    }
}

extension NBodyUniverse {
    /// Load universe from a text file asynchronously.
    /// - Parameter url: URL of the text file
    private func loadUniverseFrom(url: URL) async {
        guard let content = try? String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: "\n") else { return }
        if let radius: Double = Double(content[1]) {
            self.radius = radius
            for line in content {
                guard let planet = Planet(line) else { continue }
                self.planets.append(planet)
            }
        }
    }
    
    /// Initialize a new universe from a text file asynchronously.
    /// - Parameter fileURL: URL of the text file
    public convenience init(fileURL: URL) async {
        self.init(radius: 0, planets: [])
        await loadUniverseFrom(url: fileURL)
    }
}
