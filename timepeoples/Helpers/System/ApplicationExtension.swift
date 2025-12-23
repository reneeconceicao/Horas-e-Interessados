//
//  ApplicationExtension.swift
//  manicureaesthetics
//
//  Created by Renêe Conceição on 16/11/25.
//

import SwiftUI

extension UIApplication {
    static func rootController() -> UIViewController {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = scene.windows.first?.rootViewController else {
            return UIViewController()
        }
        return root
    }
}
