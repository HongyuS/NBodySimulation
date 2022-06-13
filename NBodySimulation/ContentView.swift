//
//  ContentView.swift
//  NBodySimulation
//
//  Created by Hongyu Shi on 2022/6/9.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("simuTime") private var simuTime: Double = 10_000 // 10_000
    @AppStorage("frameRate") private var frameRate: Int = 60 // 60
    @State private var isImporting: Bool = false
    @State private var isSimulating: Bool = false
    
    @EnvironmentObject var universe: NBodyUniverse
    
    var body: some View {
        VStack {
            HStack(spacing: 32) {
                Button {
                    isImporting = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .imageScale(.medium)
                            .foregroundColor(.primary)
                        Text("Load Universe")
                    }
                }
                Button {
                    isSimulating.toggle()
                    Task(priority: .high) {
                        while isSimulating {
                            universe.updateUniverse(dt: simuTime)
                            try! await Task.sleep(nanoseconds: fps2Nanosec(frameRate))
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: isSimulating ? "pause.fill" : "play.fill")
                            .imageScale(.medium)
                            .foregroundColor(.primary)
                    }
                }
            }.padding()
            
            UniverseView()
                .frame(minWidth: 375 - 16,
                       minHeight: 375 - 16)
                .aspectRatio(1, contentMode: .fit)
        }
        .padding()
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.plainText],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { fatalError() }
                Task {
                    await universe.reloadUniverseFrom(url: selectedFile)
                }
            } catch {
                // Handle failure.
                print("Unable to load universe from file")
                print(error.localizedDescription)
            }
        }
    }
    
    private func fps2Nanosec(_ fps: Int) -> UInt64 {
        1_000_000_000 / UInt64(fps)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(NBodyUniverse.emptyUniverse)
    }
}
