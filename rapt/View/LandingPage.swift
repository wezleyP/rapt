//
//  LandingPage.swift
//  rapt
//
//  Created by Wesley Patterson on 6/26/23.
//

import SwiftUI

struct LandingPage: View {
    var body: some View {
        VStack {
            //top Text
            VStack {
                Text("~Name~")
                    .font(
                        Font.custom("Inter", size: 50)
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                //Slogan
                

                
                Text("Insert slogan here lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem psion ")
                    .font(Font.custom("Inter", size: 15))
                    .foregroundColor(.white)
                    .frame(width: 268, height: 68, alignment: .topLeading)
              
                VStack {
                    Carousel()
                }
            }// first VStack
            
            

            VStack{
                
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 268, height: 45)
                  .background(Color(red: 0.16, green: 0.82, blue: 0.84))
                  .cornerRadius(20)
                  .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                  .overlay(Text("Create Account").font(
                      Font.custom("Inter", size: 20)
                          .weight(.bold)))


                HStack {
                    Text("Already have an account? ")
                      .font(
                        Font.custom("Inter", size: 14)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(.white)
                      .frame(width: 191, height: 31, alignment: .center)
                    Text("Login")
                      .font(
                        Font.custom("Inter", size: 21)
                          .weight(.bold)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.16, green: 0.82, blue: 0.84))
                      .frame(width: 57, height: 31, alignment: .center)
                      .padding(10)
                }
            }// second VStack
        }
        .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black, Color.purple]),
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading
                    )
                )
    }
}


struct LandingPage_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage().preferredColorScheme(.dark)
    }
}

struct Carousel: View {
  struct CarouselItemOne: View {
      var body: some View {
        VStack(spacing: 75) {
          Text("Track your Habits and \n make it competitive")
              .font(.title)
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 268, height:75)
            .background(Color(red: 0.16, green: 0.82, blue: 0.84))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .overlay(Text("").font(
                Font.custom("Inter", size: 20)
                    .weight(.bold)))
          }
        }
  }
  struct CarouselItemTwo: View {
      var body: some View {
        VStack(spacing: 30) {
          Text("Chat with friends \nand stay up to date  with their creative endeavors.")
              .font(.title)
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 268, height: 45)
            .background(Color(red: 0.16, green: 0.82, blue: 0.84))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .overlay(Text("").font(
                Font.custom("Inter", size: 20)
                    .weight(.bold)))

          }
        }
  }
  struct CarouselItemThree: View {
      var body: some View {
        VStack(spacing: 30) {
          Text("Habits")
              .font(.title)
          Rectangle()
            .foregroundColor(.clear)
            .frame(width: 268, height: 45)
            .background(Color(red: 0.16, green: 0.82, blue: 0.84))
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
            .overlay(Text("").font(
                Font.custom("Inter", size: 20)
                    .weight(.bold)))

          }
        }
  }
    var body: some View {
        TabView {
          CarouselItemOne()
          CarouselItemTwo()
          CarouselItemThree()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
    }
}


