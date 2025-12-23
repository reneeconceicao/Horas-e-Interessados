import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme

    init() {
        let saved = UserDefaults.standard.string(forKey: "selectedTheme") ?? "default"
        self.currentTheme = ThemeManager.theme(for: saved)
        applyNavigationBarTheme(animated: false)
    }

    func setTheme(_ name: String) {
        self.currentTheme = ThemeManager.theme(for: name)
        saveTheme(name)
        applyNavigationBarTheme(animated: true)
    }

    private func saveTheme(_ name: String) {
        UserDefaults.standard.set(name, forKey: "selectedTheme")
    }

    private func applyNavigationBarTheme(animated: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(currentTheme.primaryColor)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        // Define como padrão (para novas telas)
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // Atualiza a barra visível imediatamente
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let nav = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController?.findNavigationController() {

            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance

            if animated {
                UIView.animate(withDuration: 0.25) {
                    nav.navigationBar.layoutIfNeeded()
                }
            }
        }
    }

    static func theme(for name: String) -> AppTheme {
        switch name {
        case "green": return GreenTheme()
        case "brown": return BrownTheme()
        case "blue": return BlueTheme()
        case "red": return RedTheme()
        case "orange": return OrangeTheme()
        case "pink": return PinkTheme()
        
        default: return DefaultTheme()
        }
    }
}

extension UIViewController {
    func findNavigationController() -> UINavigationController? {
        if let nav = self as? UINavigationController {
            return nav
        }
        for child in children {
            if let found = child.findNavigationController() {
                return found
            }
        }
        if let presented = presentedViewController {
            return presented.findNavigationController()
        }
        return nil
    }
}
