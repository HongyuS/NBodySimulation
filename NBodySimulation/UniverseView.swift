//
//  UniverseView.swift
//  NBodySimulation
//
//  Created by Hongyu Shi on 2022/6/10.
//

import SwiftUI

struct UniverseView: View {
    @EnvironmentObject var universe: NBodyUniverse
    
    var body: some View {
        GeometryReader { geometry in
            let frameRadius = min(geometry.size.width, geometry.size.height) / 2
            ZStack {
                if universe.planetCount > 0 {
                    Color.black
                    ForEach(universe.planets, id: \.id) { planet in
                        let xxPosOnScr: CGFloat = frameRadius + CGFloat(planet.xxPos / universe.radius) * frameRadius
                        let yyPosOnScr: CGFloat = frameRadius + CGFloat(planet.yyPos / universe.radius) * frameRadius
                        let position: CGSize = .init(width: xxPosOnScr,
                                                     height: yyPosOnScr)
                        Circle()
                            .size(width: frameRadius / sizeFactorOf(name: planet.name),
                                  height: frameRadius / sizeFactorOf(name: planet.name))
                            .foregroundColor(colorOf(name: planet.name))
                            .offset(position)
                    }
                } else {
                    Rectangle()
                        .foregroundColor(.secondary.opacity(0.2))
                        .overlay {
                            Image(systemName: "square.and.arrow.down")
                                .font(.system(size: frameRadius))
                                .foregroundColor(.primary.opacity(0.2))
                        }
                }
            }
            .frame(width: frameRadius * 2, height: frameRadius * 2)
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        }.padding()
    }
}

// MARK: - Fetch Planet Property by Name
extension UniverseView {
    private func sizeFactorOf(name: String) -> CGFloat {
        getPlanetPropertyBy(name: name).sizeFraction
    }
    private func colorOf(name: String) -> Color {
        getPlanetPropertyBy(name: name).color
    }
    private func getPlanetPropertyBy(name: String) -> PlanetViewProperty {
        switch name {
        case "sun": return .sun
        case "mercury": return .mercury
        case "venus": return .venus
        case "earth": return .earth
        case "mars": return .mars
        case "asteroid": return .asteroid
        case "jupiter": return .jupiter
        case "saturn": return .saturn
        case "uranus": return .uranus
        case "neptune": return .neptune
        case "pluto": return .pluto
        case "blackhole": return .blackhole
        case "star": return .star
        case "nucleus": return .nucleus
        case "electron": return .electron
        case "pin": return .pin
        case "ball": return .ball
        case "death_star": return .death_star
        case "endor": return .endor
        case "rebel_cruiser": return .rebel_cruiser
        case "its_a_trap": return .its_a_trap
        case "star_destroyer": return .star_destroyer
        default: return .star
        }
    }
}

struct PlanetViewProperty {
    let sizeFraction: CGFloat
    let color: Color
    
    // Solar System
    static var sun: Self { Self(sizeFraction: 12, color: .white) }
    static var mercury: Self { Self(sizeFraction: 38, color: .gray) }
    static var venus: Self { Self(sizeFraction: 35, color: .yellow) }
    static var earth: Self { Self(sizeFraction: 25, color: .blue) }
    static var mars: Self { Self(sizeFraction: 30, color: .red) }
    static var asteroid: Self { Self(sizeFraction: 45, color: .gray) }
    static var jupiter: Self { Self(sizeFraction: 16, color: .orange) }
    static var saturn: Self { Self(sizeFraction: 17, color: .yellow) }
    static var uranus: Self { Self(sizeFraction: 20, color: .green) }
    static var neptune: Self { Self(sizeFraction: 20, color: .green) }
    static var pluto: Self { Self(sizeFraction: 40, color: .gray) }
    // General
    static var blackhole: Self { Self(sizeFraction: 10, color: .brown) }
    static var star: Self { Self(sizeFraction: 30, color: .yellow) }
    // Atom
    static var nucleus: Self { Self(sizeFraction: 15, color: .white) }
    static var electron: Self { Self(sizeFraction: 45, color: .yellow) }
    // Pin Ball
    static var pin: Self { Self(sizeFraction: 10, color: .white) }
    static var ball: Self { Self(sizeFraction: 15, color: .gray) }
    // STAR WARS
    static var death_star: Self { Self(sizeFraction: 20, color: .gray) }
    static var endor: Self { Self(sizeFraction: 10, color: .green) }
    static var rebel_cruiser: Self { Self(sizeFraction: 50, color: .orange) }
    static var its_a_trap: Self { Self(sizeFraction: 30, color: .yellow) }
    static var star_destroyer: Self { Self(sizeFraction: 40, color: .white) }
}

struct UniverseView_Previews: PreviewProvider {
    static var previews: some View {
        UniverseView().environmentObject(NBodyUniverse.emptyUniverse)
    }
}
