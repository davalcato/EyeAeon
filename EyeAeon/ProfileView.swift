import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userModel: UserModel
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var showSuccessMessage: Bool = false

    var body: some View {
        VStack {
            if let profileImage = userModel.profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding()
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                    .padding()
            }

            Button(action: {
                showImagePicker = true
            }) {
                Text("Change Profile Picture")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(selectedImage: $selectedImage)
                    .onDisappear {
                        if let selectedImage = selectedImage {
                            userModel.updateProfileImage(selectedImage)
                        }
                    }
            })

            TextField("First Name", text: $userModel.firstName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            TextField("Last Name", text: $userModel.lastName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            TextField("Email", text: $userModel.email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)

            Button(action: {
                userModel.saveUserInfo()
                showSuccessMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSuccessMessage = false
                }
            }) {
                Text("Save")
                    .font(.headline)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.top, 20)
            }

            if showSuccessMessage {
                Text("Your account information has successfully been saved")
                    .foregroundColor(.green)
                    .padding(.top, 10)
            }

            Spacer()
        }
        .navigationTitle("Profile")
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        })
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(UserModel())
    }
}



#Preview {
    ProfileView().environmentObject(UserModel())
}
