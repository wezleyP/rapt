//
//  Login.swift
//  rapt
//
//  Created by Wesley Patterson on 6/26/23.
//

import SwiftUI
import PhotosUI
import Firebase

struct Login: View {
    @State var emailID: String = ""
    @State var passwordID: String = ""
    
    // Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing:10) {
            Text("Sign In")
                .font(.largeTitle.bold())
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
                Button {
                    loginUser()
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                        .hAlign(.center)
                        .fillView(.purple)
                        .padding(10)
                }// login button
                Button("Reset Password", action: {resetPassword()})
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.indigo)
                    .padding(10)
            }//V2
            HStack {
             Text("Don't have an account?")
                Button("Register", action: {
                    createAccount.toggle()
                })
                    .foregroundColor(.purple)
                    .fontWeight(.bold)
            }.vAlign(.bottom)
            
        }//V1
        .vAlign(.top).padding(15)
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView().preferredColorScheme(.dark)
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }//body
    
    func loginUser() {
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: passwordID)
            } catch {
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    func resetPassword() {
        Task {
            do {
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
            } catch {
                await setError(error)
            }
        }
    }
}// Login View

// Sign Up View
struct RegisterView: View {
    @State var emailID: String = ""
    @State var passwordID: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilPicData: Data?
    
    // Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    
    var body: some View {
        VStack(spacing:10) {
            Text("Sign Up")
                .font(.largeTitle.bold())
                .hAlign(.leading)

            // For smaller screens ViewBuilder
            ViewThatFits {
                ScrollView(.vertical, showsIndicators: false) {
                    HelperView()
                }
                HelperView()
            }
            
            HStack {
                Text("Already have an account?")
                Button("Login"){
                    dismiss()
                }
                    .foregroundColor(.purple)
                    .fontWeight(.bold)
            }.vAlign(.bottom)
        }//V1
        .vAlign(.top).padding(15)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        await MainActor.run(body:  {
                            userProfilPicData = imageData
                        })
                    } catch {}
                }
            }
        }
    }//body
    
    @ViewBuilder
    func HelperView()-> some View {
        VStack(spacing: 12) {
            ZStack {
                if let userProfilPicData, let image = UIImage(data: userProfilPicData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName:"person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
                .frame(width: 85, height: 85)
                .clipShape(Circle())
                .contentShape(Circle())
                .onTapGesture {
                    showImagePicker.toggle()
                }
            
            TextField("User Name", text: $userName)
                .textContentType(.emailAddress)
                .border(1.2, .white)
                .padding(.top, 25)
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1.2, .white)
                .padding(.top, 25)
            SecureField("Password", text: $passwordID)
                .textContentType(.password)
                .border(1.2, .white)
                .padding(.top, 25)
            TextField("Bio: ex: I'm a angry boy by the name of Xole", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1.2, .white)
                .padding(.top, 25)
            TextField("Bio Link (optional)", text: $userBioLink)
                .textContentType(.emailAddress)
                .border(1.2, .white)
                .padding(.top, 25)
            Button {

            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.purple)
                   
            }// login button
            .padding(10)
        }//V2
    }// VB
}// sign up View

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
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
        }
    }
}
