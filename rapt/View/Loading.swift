//
//  Loading.swift
//  rapt
//
//  Created by Wesley Patterson on 7/7/23.
//

import SwiftUI

struct Loading: View {
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            if show {
                Group {
                    Rectangle()
                        .fill(Color.black.opacity(0.25))
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .padding(15)
                        .background(Color.white, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: show)
    }
}



