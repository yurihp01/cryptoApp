//
//  AppCoordinatorView.swift
//  cryptoApp
//
//  Created by Yuri on 04/07/25.
//

import SwiftUI

struct AppCoordinatorView: View {
    @ObservedObject var coordinator: AppCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(.list)
            .navigationDestination(for: AppRoute.self) { route in
                coordinator.build(route)
            }
        }
    }
}
