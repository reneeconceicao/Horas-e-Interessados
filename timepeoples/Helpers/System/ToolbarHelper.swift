//
//  ToolbarHelper.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 26/04/25.
//

import SwiftUI
import SwiftUIIntrospect

extension View {
    @ViewBuilder
    func applyHiddenScrollIndicators() -> some View {
        if #available(iOS 16, *) {
            self.scrollIndicators(.hidden)
        } else {
            self.introspect(.scrollView, on: .iOS(.v15)) { scrollView in
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
            }
        }
    }
}


func setupNavigationBarAppearance(
    backgroundColor: UIColor,
    titleColor: UIColor = .white,
    buttonColor: UIColor = .white
) {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = backgroundColor
    appearance.titleTextAttributes = [.foregroundColor: titleColor]
    appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

    let navigationBar = UINavigationBar.appearance()
    navigationBar.standardAppearance = appearance
    navigationBar.scrollEdgeAppearance = appearance
    navigationBar.compactAppearance = appearance
    navigationBar.tintColor = buttonColor 

    
    UIBarButtonItem.appearance().tintColor = buttonColor
}

