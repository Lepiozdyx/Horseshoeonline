//
//  RegistrationView.swift
//  Horseshoe
//
//  Created by Alex on 04.12.2024.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject private var vm = RegistrationViewModel()
    @FocusState private var isFocused: Bool
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack {
                Text("REGISTRATION")
                    .hsfont(.yellow, 40)
                
                Spacer()
                
                VStack {
                    Text("NAME")
                        .hsfont(.yellow, 20)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.black.opacity(0.5))
                            .frame(width: 333, height: 64)
                            
                        TextField("", text: $vm.username)
                            .focused($isFocused)
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundStyle(.white)
                            .font(.system(size: 24, weight: .bold))
                            .submitLabel(.done)
                    }
                }
                
                Spacer()
                
                Button {
                    vm.saveUsername()
                    onComplete()
                } label: {
                    UnderlayView(
                        text: "NEXT",
                        fontSize: 20,
                        fontColor: .customRed,
                        width: 237,
                        height: 64
                    )
                }
                .disabled(vm.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .opacity(vm.username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.5 : 1)

            }
            .padding()
        }
    }
}

#Preview {
    RegistrationView(onComplete: {})
}
