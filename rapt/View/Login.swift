//
//  Login.swift
//  rapt
//
//  Created by Wesley Patterson on 6/26/23.
//

import SwiftUI

struct Login: View {
    @State var emailID: String = ""
    @State var passwordID: String = ""
    
    var body: some View {
        VStack(spacing:10) {
            Text("Sign In").font(.largeTitle.bold())
                .hAlign(.leading)
            
            VStack(spacing: 12) {
                TextField("Email", text: $emailID)
                    .textContentType(.emailAddress)
                    .border(1.2, .white)
                    .padding(.top, 25)
                SecureField("Password", text: $passwordID)
                    .textContentType(.password)
                    .border(1.2, .white)
                    .padding(.top, 25)
                Button("Reset Password", action: {})
                    .font(.callout)
                    .fontWeight(.medium)
                    .tint(.blue)
            }
            
        }.vAlign(.top).padding(15)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().preferredColorScheme(.dark)
    }
}

extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight:  .infinity, alignment: alignment)
    }
    func border(_ width: Double,_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width )
            }
    }
}
