//
//  ContentView.swift
//  Haikingu Watch App
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
                    if appState.showMetricsScreen {
                        MetricsScreen()
                    } else {
                        HomeScreen()
                    }
                }
    }
}

#Preview {
    ContentView()
}
