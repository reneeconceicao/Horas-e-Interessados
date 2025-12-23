//
//  ActivityViewController.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 16/04/25.
//

import SwiftUI

struct ShareFileSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activity, success, items, error in
            isPresented = false
        }
        return activityVC
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    
    static func presentShareSheet(items: [Any]) {
        guard let topController = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first?.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        if let sheet = activityVC.sheetPresentationController {
            sheet.detents = [.large()]
        }
        
        topController.present(activityVC, animated: true)
    }
}
