//
//  HTDarkModeInit.swift
//  HeartTrip
//
//  Created by vin on 2020/11/23.
//  Copyright © 2020 BinBear. All rights reserved.
//

import UIKit
import FluentDarkModeKit

class HTDarkModeInit: NSObject {
    @objc func toInit() {
        let configuration = DMEnvironmentConfiguration()
        configuration.themeChangeHandler = {
            print("theme changed")
        }
        if #available(iOS 13.0, *) {
            configuration.windowThemeChangeHandler = { window in
                print("\(window) theme changed")
            }
        }
        DarkModeManager.setup(with: configuration)
        DarkModeManager.register(with: UIApplication.shared)
    }
}
