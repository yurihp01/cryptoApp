//
//  EnvironmentValues+Extensions.swift
//  cryptoApp
//
//  Created by Yuri on 03/07/25.
//

import SwiftUI

private struct AppDependenciesKey: EnvironmentKey {
    static let defaultValue: AppDependencies = AppDependencies(symbols: [])
}

extension EnvironmentValues {
    var appDependencies: AppDependencies {
        get { self[AppDependenciesKey.self] }
        set { self[AppDependenciesKey.self] = newValue }
    }
}
