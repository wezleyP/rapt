//
//  Login.swift
//  rapt
//
//  Created by Wesley Patterson on 6/26/23.
//

import SwiftUI
import Combine
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


struct Login: View {
    @State var emailID: String = ""
    @State var passwordID: String = ""
    
    // Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool = false
    
    // User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
  
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
        .overlay(content: {
          Loading(show: $isLoading)
        })
        .fullScreenCover(isPresented: $createAccount) {
            RegisterView().preferredColorScheme(.dark)
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }//body
    
    func loginUser() {
      isLoading = true
      closeKeyBoards()
        Task {
            do {
                try await Auth.auth().signIn(withEmail: emailID, password: passwordID)
              print("user found")
              try await fetchUser()
            } catch {
                await setError(error)
            }
        }
    }
    
    func setError(_ error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
    
    func fetchUser() async throws {

    guard let userID = Auth.auth().currentUser?.uid else {return}
    let user = try await Firestore.firestore().collection("User").document(userID).getDocument(as: User.self)
    await MainActor.run(body: {
      userUID = userID
      userNameStored = user.userName
      profileURL = user.userProfileURL
      logStatus = true
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
}// login View


struct RegisterView: View {
    @State var emailID: String = ""
    @State var passwordID: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilePicData: Data?
    @State var isLoading: Bool = false
    // Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
  
    // User Defaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
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
        .overlay(content: {
          Loading(show: $isLoading)
        })
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue {
                Task {
                    do {
                        guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                        await MainActor.run(body:  {
                            userProfilePicData = imageData
                        })
                    } catch {}
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
    }//body
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack(spacing: 12) {
            ZStack {
                if let userProfilePicData, let image = UIImage(data: userProfilePicData) {
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
          Button(action: registerUser) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .hAlign(.center)
                    .fillView(.purple)
          }
          .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || passwordID == "" || userBio == "" || userProfilePicData == nil)
            .padding(10)
        }//V2
    }// VB
  
  func registerUser() {
    isLoading = true
    closeKeyBoards()
    Task {
      do {
        try await Auth.auth().createUser(withEmail: emailID, password: passwordID)
        guard let userUID = Auth.auth().currentUser?.uid else {return}
        guard let imageData = userProfilePicData else {return}
        let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
        let _ = try await storageRef.putDataAsync(imageData)
        
        let downloadURL = try await storageRef.downloadURL()
        
        let user = User(userName: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: downloadURL)
        
        let _ = try Firestore.firestore().collection("User").document(userUID).setData(from: user, completion: {
          error in
          if error == nil {
            print("Saved Successfully")
            userNameStored = userName
            self.userUID = userUID
            profileURL = downloadURL
            logStatus = true
          }
        })
      } catch {
        await setError(error)
      }
    }
  }
  
  func setError(_ error: Error) async {
      await MainActor.run(body: {
          errorMessage = error.localizedDescription
          showError.toggle()
          isLoading = false
      })
  }
}// sign up View

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login().preferredColorScheme(.dark)
    }
}

extension View {
  func closeKeyBoards () {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
  
  func disableWithOpacity(_ condition: Bool) -> some View {
    self
      .disabled(condition)
      .opacity(condition ? 0.6 : 1)
  }
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
