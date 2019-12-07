//
//  ConfigType.swift
//
//  Created by Juan Cruz Ghigliani on 11/5/18.
//

import Foundation

/// Base App config protocol
protocol ConfigType {
    var environment: Environment { get }
    var appVersion: String { get }
    var buildNumber: String { get }
    var locale: Locale { get }
}

/// Base App config implementation
struct Config: ConfigType {

    let environment: Environment
    let appVersion: String
    let buildNumber: String
    let locale: Locale

    /// Init an instance of Config with the provided values
    ///
    /// - Parameters:
    ///   - environment: Environment type
    ///   - appVersion: App Version description
    ///   - buildNumber: Build number description
    ///   - locale: User Locale instance
    init(environment: Environment, appVersion: String, buildNumber: String, locale: Locale) {
        self.environment = environment
        self.appVersion = appVersion
        self.buildNumber = buildNumber
        self.locale = locale
    }

    /// Init an instance of Config with the provided by the bundle
    ///
    /// - Parameters:
    ///   - bundle: Bundle instance with keys "Environment", "CFBundleShortVersionString" and "CFBundleVersion"
    ///   - locale: Locale instance
    init(bundle: Bundle, locale: Locale) {

        self.locale = locale

        if let envString = bundle.object(forInfoDictionaryKey: "Environment") as? String,
            let env = Environment(rawValue: envString) {
            self.environment = env
        } else {
            self.environment = Environment.dev
        }

        self.appVersion = (bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String) ?? "Invalid CFBundleShortVersionString"

        self.buildNumber = (bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String) ?? "Invalid CFBundleVersion"
    }

}
