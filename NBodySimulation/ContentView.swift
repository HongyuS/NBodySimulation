//
//  ContentView.swift
//  NBodySimulation
//
//  Created by Hongyu Shi on 2022/6/9.
//

import SwiftUI

struct ContentView: View {
    @State private var isImporting: Bool = false
    @State private var isSimulating: Bool = false
    
    @EnvironmentObject var universe: NBodyUniverse
    
    var body: some View {
        VStack {
            
            HStack {
                Button {
                    isImporting = true
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                            .imageScale(.medium)
                            .foregroundColor(.accentColor)
                        Text("Load Universe")
                    }
                }
                Button {
                    isSimulating.toggle()
                    Task {
                        while isSimulating {
                            universe.updateUniverse(dt: 10_000)
                            try! await Task.sleep(nanoseconds: 16_666_667)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: isSimulating ? "stop.fill" : "play.fill")
                            .imageScale(.medium)
                            .foregroundColor(.accentColor)
                        Text(isSimulating ? "Stop" : "Start")
                    }
                }
            }
            
            UniverseView()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(NBodyUniverse.emptyUniverse)
    }
}
