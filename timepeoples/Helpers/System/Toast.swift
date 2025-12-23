//
//  ViewExtension.swift
//  manicurecalendar
//
//  Created by Renêe Conceição on 17/04/25.
//

import SwiftUI

extension View {
    func toast(
        isPresented: Binding<Bool>,
        paddingBottom: CGFloat = 60,
        duration: TimeInterval = 2,
        message: String,
        image: String = "",
        imageColor: Color = .black
    ) -> some View {
        ZStack {
            self
            VStack {
                Spacer()
                if isPresented.wrappedValue {
                    HStack(spacing: 8) {
                        if !image.isEmpty {
                            Image(systemName: image)
                                .foregroundStyle(imageColor)
                                .imageScale(.large)
                        }
                        Text(message)
                            .foregroundStyle(.white)
                    }
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(8)
//                    .transition(.opacity) // <- anima entrada e saída
//                    .transition(.move(edge: .bottom).combined(with: .opacity)) // <- anima entrada e saída
                    .transition(.opacity) // <- anima entrada e saída
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                            withAnimation {
                                isPresented.wrappedValue = false
                            }
                        }
                    }
                }
            }
            .padding(.bottom, paddingBottom)
            .padding(.horizontal)
            .animation(.easeInOut, value: isPresented.wrappedValue)
            .zIndex(1)
        }
    }
}


