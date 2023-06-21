//
//  OnboardingView.swift
//  OnboardingApp
//
//  Created by Tim on 2023/6/21.
//

import SwiftUI

struct OnboardingView: View {
    // 入职状态:
    /*
     0 - 欢迎页面
     1 - 输入姓名
     2 - 输入年龄
     3 - 输入性别
     */
    @State var onboardState : Int = 0
    
    private let transition : AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )
    
    // 输入保存值
    @State var name : String = ""
    @State var age : Double  = 30
    @State var gender : String = ""
    
    
    // 警告内容
    @State var alertTitle : String = ""
    @State var isShowAlert : Bool  = false
    
    // app storge
    @AppStorage("name")   var currentUserName : String?
    @AppStorage("age")    var currentUserAge  : Int?
    @AppStorage("gender") var currentUserGender : String?
    @AppStorage("signed_in") var currentUserSignedIn = false

    var body: some View {
        ZStack {
            switch onboardState {
            case 0:
                welcomeSection
            case 1:
                addNameSection
                    .transition(transition)
            case 2:
                addAgeSection
                    .transition(transition)
            case 3:
                addGenderSection
                    .transition(transition)
            default:
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.green)
            }
            
            VStack {
                Spacer()
                bottomButton
            }
            .padding(30)
        }
        .alert(isPresented: $isShowAlert) {
            return Alert(title: Text(alertTitle))
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .background(Color.purple)
    }
}

// MARK: - COMPONENT
extension OnboardingView {
    private var bottomButton : some View {
        Text(onboardState == 0 ? "SIGN UP" : onboardState == 3 ? "FINISH" : "NEXT")
            .font(.headline)
            .foregroundColor(.purple)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .animation(nil)
            .onTapGesture {
                handleNextButtonPressed()
            }
    }
    
    private var welcomeSection : some View {
        VStack(spacing: 30) {
            Spacer()
            Image(systemName: "heart.text.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .foregroundColor(.white)
            Text("Find your match.")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .overlay(
                    Capsule(style: .continuous)
                        .foregroundColor(.white)
                        .frame(height: 3)
                        .offset(y: 10)
                    , alignment: .bottom
                )
            Text("This is the #1 app for finding your match online! In this tutorial we are practicing using AppStorge and other SwiftUI techniques.")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal)
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .padding(30)
    }
    
    
    private var addNameSection : some View {
        VStack(spacing: 30) {
            Spacer()
            Text("What's your name?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            TextField("Your name here ...", text: $name)
                .frame(height: 55)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    private var addAgeSection : some View {
        VStack(spacing: 30) {
            Spacer()
            Text("What's your Age?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Text(String(format: "%.0f", age))
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            Slider(value: $age, in: 18 ... 80, step: 1)
                .accentColor(.white)
            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
    
    private var addGenderSection : some View {
        VStack(spacing: 30) {
            Spacer()
            Text("What's your Gender?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Menu {
                Button("Male") {
                    gender = "Male"
                }
                
                Button("Female") {
                    gender = "Male"
                }
                
                Button("Non-Binary") {
                    gender = "Non-Binary"
                }
                
            } label: {
                Text(gender.count > 1 ? gender : "Select a Gender")
                    .font(.headline)
                    .foregroundColor(.purple)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
            }

            Spacer()
            Spacer()
        }
        .padding(30)
    }
    
}

// MARK: - FUNCTIONS
extension OnboardingView {
    private func handleNextButtonPressed() {
        // CHECK INPUTS
        switch onboardState {
        case 1:
            guard name.count >= 3 else {
                showAlert(title: "Your name must be at least 3 characters long! 🤷‍♂️")
                return
            }
        case 3:
            guard gender.count > 1 else {
                showAlert(title: "Please select a gender before moving forward! 🤷‍♀️")
                return
            }
        default: break
        }
        
        // GO TO NEXT COMPONENT
        if onboardState == 3 {
            // sign in
            signIn()
        } else {
            withAnimation(.spring()) {
                onboardState += 1
            }
        }
    }
    
    private func signIn() {
        currentUserName = name
        currentUserAge  = Int(age)
        currentUserGender = gender
        withAnimation(.spring()) {
            currentUserSignedIn = true
        }
    }
    
    private func showAlert(title: String) {
        alertTitle = title
        isShowAlert.toggle()
    }
}
