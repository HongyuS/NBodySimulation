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
    
    public required init(radius: Double, planets: [Planet]) {
        self.radius = radius
        self.planets = planets
    }
}

extension NBodyUniverse {
    /// Update a planet's position and velosity, given the net force and time.
    /// - Parameter dt: a small period of time
    @MainActor
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
    /// Load a universe from a text file asynchronously.
    /// - Parameter url: URL of the text file
    private static func loadUniverseFrom(url: URL) async -> (Double, [Planet])? {
        guard let content = try? String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: "\n") else { return nil }
        guard let r: Double = Double(content[1]) else { return nil }
        var planets: [Planet] = []
        for line in content {
            guard let planet = Planet(line) else { continue }
            planets.append(planet)
        }
        return (r, planets)
    }
    
    /// Reload the universe from a text file asynchronously.
    /// - Parameter url: URL of the text file
    @MainActor
    public func reloadUniverseFrom(url: URL) async {
        reset()
        guard let (r, planets) = await Self.loadUniverseFrom(url: url) else { return }
        self.radius = r
        self.planets = planets
    }
    
    /// Initialize a new universe from a text file asynchronously.
    /// - Parameter fileURL: URL of the text file
    public convenience init(fileURL: URL) async {
        guard let (r, planets) = await Self.loadUniverseFrom(url: fileURL) else {
            self.init(radius: 0, planets: [])
            return
        }
        self.init(radius: r, planets: planets)
    }
    
    /// Reset the universe to empty.
    @MainActor
    private func reset() {
        radius = .zero
        planets.removeAll()
    }
    
    /// Create an empty universe.
    public static var emptyUniverse: Self {
        .init(radius: 0, planets: [])
    }
}
