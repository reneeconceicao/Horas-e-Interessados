//
//  MonthYearPicker.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 06/04/25.
//


import SwiftUI

struct MonthYearPicker: UIViewRepresentable {
    @Binding var date: Date
    var onChange: ((Date) -> Void)? = nil

    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale.current
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return picker
    }

    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = date
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject {
        var parent: MonthYearPicker

        init(parent: MonthYearPicker) {
            self.parent = parent
        }

        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.date = sender.date
            parent.onChange?(sender.date)
        }
    }
}
