//
//  User.swift
//  rapt
//
//  Created by Wesley Patterson on 7/7/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
  @DocumentID var id: String?
  var userName: String
  var userBio: String
  var userBioLink: String
  var userUID: String
  var userEmail: String
  var userProfileURL: URL
  
  enum CodingKeys: CodingKey {
    case id
    case userName
    case userBio
    case userBioLink
    case userUID
    case userEmail
    case userProfileURL
  }
}

