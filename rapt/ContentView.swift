//
//  ContentView.swift
//  rapt
//
//  Created by Wesley Patterson on 6/26/23.
//

import SwiftUI

//
struct ContentView: View {
  @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
      if logStatus{
        Text("Main View")
      } else {
        Login()
      }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}
