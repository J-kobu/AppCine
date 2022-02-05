//
//  SigninView.swift
//  AppCine
//
//  Created by Jacob Aguilar on 31-01-22.
//

import SwiftUI
import Lottie

struct SigninView: View {
    
    var body: some View {
       
        NavigationView {
            ZStack {
                Color("BackgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                   
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 40)
                    
                    SignInAndSingUpView()
                    
                }
            }
            .navigationBarHidden(true)
        }
        
            
    }
}


struct SignInAndSingUpView: View {
    
    @State var signInType = true
    
    var body: some View {
        
        VStack {
            HStack {
                
                Spacer()
                
                Button {
                    withAnimation(Animation.default) {
                        signInType = true
                    }
                } label: {
                    Text("SIGN IN")
                        .foregroundColor(signInType ? Color(.white) : Color(.gray))
                        .font(.system(size: 22, weight: signInType ? .bold : .regular, design: .rounded))
                }
                
                Spacer()
                
                Button {
                    withAnimation(Animation.easeInOut) {
                        signInType = false
                    }
                } label: {
                    Text("SIGN UP")
                        .foregroundColor(signInType ? Color(.gray) : Color(.white))
                        .font(.system(size: 22, weight: signInType ? .regular : .bold, design: .rounded))
                }
                
                Spacer()
            }
            
            Spacer()
            
            if signInType == true {
                withAnimation(Animation.easeOut(duration: 10)) {
                    SignInView()
                        .transition(.move(edge: .leading))
                        
                }
                
                    
            } else {
                withAnimation(Animation.easeOut(duration: 10)) {
                    SignUpView()
                        .transition(.move(edge: .trailing))
                }
                
            }

        }
        
    }
}

struct SignInView: View {
    
    @ObservedObject var signupSigninValidation = SigninSignupValidation()
    @State var isSecure: Bool = true
    @State var isSingInfieldsComplete: Bool = false
    @State var isUserNotFound = false
    
    var body: some View {
        
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    
                    Text("Email")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, -1)
                        .padding(.leading, 4)
                    
                    //Email field
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.leading)
                        
                        ZStack(alignment: .leading) {
                            
                            if signupSigninValidation.email.isEmpty {
                                Text(verbatim: "example@example.com")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                            
                            TextField("", text: $signupSigninValidation.email)
                                .foregroundColor(.white)
                                .keyboardType(.emailAddress)
                                .font(.body)
                                .padding(15)
                                .padding(.leading, -10)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
         
                        }
                    }
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .padding(.top, 0)
                    
                    if !signupSigninValidation.email.isEmpty {
                        ValidationFormView(iconName: signupSigninValidation.isEmailValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isEmailValid ? Color.green : Color.red, baseForegroundColor: Color.white, formText: "Write a valid email", conditionChecked: signupSigninValidation.isEmailValid)
                    }
                    
                    Text("Password")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, 20)
                        .padding(.bottom, -0.5)
                        .padding(.leading, 4)
                    
                    //Password field
                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .padding(.leading)
                        
                        ZStack(alignment: .leading) {
                            
                            if signupSigninValidation.password.isEmpty {
                                Text(verbatim: "Enter your password")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                            
                            if isSecure {
                                SecureField("", text: $signupSigninValidation.password)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .padding(15)
                                    .padding(.leading, -10)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                            } else {
                                TextField("", text: $signupSigninValidation.password)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .padding(15)
                                    .padding(.leading, -10)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                            }
                           
         
                        }
                        
                        Button {
                            withAnimation(Animation.default) {
                                isSecure.toggle()
                            }
                            
                        } label: {
                            
                            isSecure ? Image(systemName: "eye")
                                .foregroundColor(Color("ButtonsColor"))
                                .padding(.trailing) : Image(systemName: "eye.slash")
                                .foregroundColor(Color(.red))
                                .padding(.trailing)
                                                     
                        }

                    }
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)

                }
                .padding(.horizontal, 10)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Button {
                    signin()
                } label: {
                    Text("SIGN IN")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding()
                }
                .background(Color("ButtonsColor"))
                .cornerRadius(15)
                .padding(.vertical, 30)
                .alert(isPresented: $isUserNotFound) {
                    Alert(title: Text("Error"), message: Text("Email or Password not found"), dismissButton: .default(Text("Okay")))
                }
            }
            .background(Color("CardColor"))
            .cornerRadius(15)
            .padding(.horizontal, 10)
            .padding(.vertical, 20)
            
            Spacer()
            
            
            
            NavigationLink(isActive: $isSingInfieldsComplete) {
                DashboardView()
            } label: {
                EmptyView()
            }
        }
    }
    
    func signin() {
        let updateDataObject = SaveData()
        let result = updateDataObject.validate(email: signupSigninValidation.email, pass: signupSigninValidation.password)
        
        print("Result: \(result)")
        
        if result == true {
            self.isUserNotFound = false
            self.isSingInfieldsComplete = true
        } else {
            self.isUserNotFound = true
        }
    }

}


struct SignUpView: View {
    
    @ObservedObject var signupSigninValidation = SigninSignupValidation()
    @State var isSecure: Bool = true
    @State var isConfirmSecure: Bool = true
    @State var areFieldsComplete: Bool = false
    @State var areFieldsIncomplete: Bool = false
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack {
                
                VStack(alignment: .leading) {

                    
                    //Username field
                    Text("Username")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.bottom, -1)
                        .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.leading)
                        
                        ZStack(alignment: .leading) {
                            if signupSigninValidation.userName.isEmpty {
                                Text("Write your username/nickname")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                            TextField("", text: $signupSigninValidation.userName)
                                .foregroundColor(.white)
                                .keyboardType(.default)
                                .font(.body)
                                .padding(15)
                                .padding(.leading, -10)
                                .disableAutocorrection(true)
                            
                        }
                    }
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .padding(.top, 0)
                    
                    //Validation form for Username
                    if !signupSigninValidation.userName.isEmpty {
                        ValidationFormView(iconName: signupSigninValidation.isUserNameLengthValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isUserNameLengthValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Username must be at least 6 characters", conditionChecked: signupSigninValidation.isUserNameLengthValid)
                            .transition(.slide)
                    }
                    
                    
                    //Email field
                    Text("Email")
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, 10)
                        .padding(.bottom, -1)
                        .padding(.leading, 4)
                    
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                            .padding(.leading)
                        
                        ZStack(alignment: .leading) {
                            
                            if signupSigninValidation.email.isEmpty {
                                Text(verbatim: "example@example.com")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                                    .padding(.leading, 5)
                            }
                            
                            TextField("", text: $signupSigninValidation.email)
                                .keyboardType(.emailAddress)
                                .foregroundColor(.white)
                                .font(.body)
                                .padding(15)
                                .padding(.leading, -10)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
         
                        }
                    }
                    .background(Color("TextFieldColor"))
                    .cornerRadius(15)
                    .padding(.top, 0)
                    
                    //Validation form for Email
                    if !signupSigninValidation.email.isEmpty {
                        ValidationFormView(iconName: signupSigninValidation.isEmailValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isEmailValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Write a valid email", conditionChecked: signupSigninValidation.isEmailValid)
                    }

                    
                    VStack(alignment: .leading) {
                        //Password field
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top, 10)
                            .padding(.bottom, -0.5)
                            .padding(.leading, 4)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                                .padding(.leading)
                            
                            ZStack(alignment: .leading) {
                                
                                if signupSigninValidation.password.isEmpty {
                                    Text("Chose your password")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .padding(.leading, 5)
                                }
                                
                                if isSecure {
                                    SecureField("", text: $signupSigninValidation.password)
                                        .foregroundColor(.white)
                                        .keyboardType(.default)
                                        .font(.body)
                                        .padding(15)
                                        .padding(.leading, -10)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                } else {
                                    TextField("", text: $signupSigninValidation.password)
                                        .foregroundColor(.white)
                                        .keyboardType(.default)
                                        .font(.body)
                                        .padding(15)
                                        .padding(.leading, -5)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button {
                                withAnimation(Animation.default) {
                                    isSecure.toggle()
                                }
                            } label: {
                                isSecure ?
                                Image(systemName: "eye")
                                    .foregroundColor(Color("ButtonsColor"))
                                    .padding(.trailing) :
                                Image(systemName: "eye.slash")
                                    .foregroundColor(Color(.red))
                                    .padding(.trailing)
                            }

                        }
                        .background(Color("TextFieldColor"))
                        .cornerRadius(15)
                        
                        //Password form validations
                        VStack {
                            if !signupSigninValidation.password.isEmpty {
                                ValidationFormView(iconName: signupSigninValidation.isPasswordLengthValid ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isPasswordLengthValid ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Must contain at least 8 characters", conditionChecked: signupSigninValidation.isPasswordLengthValid)
                                
                                ValidationFormView(iconName: signupSigninValidation.isPasswordCapitalLetter ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.isPasswordCapitalLetter ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Must cointain at leas one capital letter", conditionChecked: signupSigninValidation.isPasswordCapitalLetter)
                            }
                            
                        }
                        
                        //Comfirm Password field
                        Text("Confirm password")
                            .foregroundColor(.white)
                            .bold()
                            .padding(.top, 10)
                            .padding(.bottom, -0.5)
                            .padding(.leading, 4)
                        
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                                .padding(.leading)
                            
                            ZStack(alignment: .leading) {
                                
                                if signupSigninValidation.confirmPassword.isEmpty {
                                    Text("Confirm your password")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                        .padding(.leading, 5)
                                }
                                
                                if isConfirmSecure {
                                    SecureField("", text: $signupSigninValidation.confirmPassword)
                                        .foregroundColor(.white)
                                        .keyboardType(.default)
                                        .font(.body)
                                        .padding(15)
                                        .padding(.leading, -10)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                } else {
                                    TextField("", text: $signupSigninValidation.confirmPassword)
                                        .foregroundColor(.white)
                                        .keyboardType(.default)
                                        .font(.body)
                                        .padding(15)
                                        .padding(.leading, -10)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                }
                            }
                            
                            Button {
                                withAnimation(Animation.default) {
                                    isConfirmSecure.toggle()
                                }
                            } label: {
                                isConfirmSecure ? Image(systemName: "eye")
                                    .foregroundColor(Color("ButtonsColor"))
                                    .padding(.trailing) : Image(systemName: "eye.slash")
                                    .foregroundColor(Color(.red))
                                    .padding(.trailing)
                            }

                        }
                        .background(Color("TextFieldColor"))
                        .cornerRadius(15)

                        //Passwords match form validation
                        if !signupSigninValidation.confirmPassword.isEmpty {
                            ValidationFormView(iconName: signupSigninValidation.arePasswordsMatch ? "checkmark.circle" : "xmark.circle", iconColor: signupSigninValidation.arePasswordsMatch ? Color.green : Color.red, baseForegroundColor: Color.gray, formText: "Passwords must match", conditionChecked: signupSigninValidation.arePasswordsMatch)
                        }
                        
                    }
                    
                }
                .padding(.horizontal, 10)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
                Button {
                    signup()
                } label: {
                    Text("SIGN UP")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding()
                }
                .background(Color("ButtonsColor"))
                .cornerRadius(15)
                .padding(.vertical, 30)
                .alert(isPresented: $areFieldsIncomplete) {
                    Alert(title: Text("ERROR"), message: Text("All fields are requiere"), dismissButton: .default(Text("Okay")))
                }
            }
            .background(Color("CardColor"))
            .cornerRadius(15)
            .padding(.horizontal, 10)
            .padding(.top, 20)
            
            Spacer()
            
            NavigationLink(isActive: $areFieldsComplete) {
                AvatarNicknameView()
            } label: {
                EmptyView()
            }

        }
    }
    
    func signup() {
        
        let saveDataObject = SaveData()
        
        if signupSigninValidation.email.isEmpty || signupSigninValidation.password.isEmpty || signupSigninValidation.userName.isEmpty {
            areFieldsComplete = false
            areFieldsIncomplete = true
        } else {
            saveDataObject.signUp(email: signupSigninValidation.email, pass: signupSigninValidation.password, username: signupSigninValidation.userName)
            areFieldsIncomplete = false
            areFieldsComplete = true
        }

    }
    
}

struct ValidationFormView: View {
    
    var iconName = "xmark.circle"
    var iconColor = Color(red: 188/255, green: 172/255, blue: 210/255)
    var baseForegroundColor = Color(red: 237/255, green: 230/255, blue: 249/255)
    var formText = ""
    var conditionChecked = false
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.system(size: 12))
            Text(formText)
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(baseForegroundColor)
                .strikethrough(conditionChecked)
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct SigninView_Previews: PreviewProvider {
    static var previews: some View {
        SigninView()
    }
}
