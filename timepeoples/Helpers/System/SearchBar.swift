//
//  SearchBar.swift
//  recipecalculatorapp
//
//  Created by Renêe Conceição on 28/05/25.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = placeholder
        searchBar.autocapitalizationType = .none
        
        let toolbar = UIToolbar()
            toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: String(localized: "Done"), style: .plain, target: context.coordinator, action: #selector(Coordinator.dismissKeyboard))
        done.setTitleTextAttributes([.foregroundColor: UIColor(.accentColor)], for: .normal)
        done.setTitleTextAttributes([.foregroundColor: UIColor(.accentColor)], for: .selected)
        done.setTitleTextAttributes([.foregroundColor: UIColor(.accentColor)], for: .highlighted)
        
        let trailingSpace = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        trailingSpace.width = 8
        
        toolbar.items = [flex, done, trailingSpace]
        searchBar.inputAccessoryView = toolbar
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        @objc func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
