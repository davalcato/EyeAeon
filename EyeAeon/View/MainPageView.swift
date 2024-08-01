//
//  MainPageView.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/15/24.
//

import SwiftUI

struct MainPageView: View {
    @State private var showLogoutAlert = false
    @State private var navigateToSplashScreen = false
    @EnvironmentObject var dataModel: SharedDataModel
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var appState: AppState

    var body: some View {
            NavigationView {
                VStack {
                    // Header
                    HStack {
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                        }
                        Spacer()
                        Text(userModel.firstName)
                            .font(.title)
                            .foregroundColor(.black)
                            .padding(.trailing, 9)
                        Button(action: {
                            showLogoutAlert = true
                        }) {
                            Image(systemName: "power")
                                .font(.system(size: 25))
                                .foregroundColor(.black)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.top, 20)

                    ScrollView {
                        // Main Section (Grid Layout)
                        VStack(spacing: 20) {
                            HStack(spacing: 20) {
                                NavigationLink(destination: TextDetectionView()) {
                                    DetectionButton(title: "Text Detection", description: "Analyze text from images", backgroundColor: Color.blue)
                                }
                                NavigationLink(destination: ImageDetectionView()) {
                                    DetectionButton(title: "Image Detection", description: "Identify objects in images", backgroundColor: Color.green)
                                }
                            }
                            HStack(spacing: 20) {
                                NavigationLink(destination: VideoDetectionView()) {
                                    DetectionButton(title: "Video Detection", description: "Analyze video content", backgroundColor: Color.red)
                                }
                                NavigationLink(destination: AudioDetectionView()) {
                                    DetectionButton(title: "Audio Detection", description: "Transcribe and analyze audio", backgroundColor: Color.yellow)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        
                        // New Section with Light Grey Background
                        VStack(spacing: 10) {
                            Text("Additional Information")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top)
                            
                            // Recent Activity Logs
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Recent Activity Logs")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                Text("• Detected text from image 'image1.jpg'")
                                Text("• Analyzed video 'video1.mp4'")
                                Text("• Transcribed audio from 'audio1.wav'")
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            // Summary Statistics
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Summary Statistics")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                Text("• Total images analyzed: \(dataModel.imageCount)")
                                Text("• Total videos analyzed: \(dataModel.videoCount)")
                                Text("• Total audio files transcribed: \(dataModel.audioCount)")
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            
                            // Links to More Resources
                            VStack(alignment: .leading, spacing: 5) {
                                Text("More Resources")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                Button(action: {
                                    // Link action for documentation
                                    print("Navigate to Documentation")
                                }) {
                                    Text("Documentation")
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    // Link action for support
                                    print("Navigate to Support")
                                }) {
                                    Text("Support")
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    // Link action for tutorials
                                    print("Navigate to Tutorials")
                                }) {
                                    Text("Tutorials")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .padding(.top, 20)
                    }

                    Spacer()

                    // Footer
                    HStack {
                        Button(action: {
                            // Action for Contact
                            print("Contact action")
                        }) {
                            Text("Contact")
                        }
                        Spacer()
                        Button(action: {
                            // Action for Privacy Policy
                            print("Privacy Policy action")
                        }) {
                            Text("Privacy Policy")
                        }
                        Spacer()
                        Button(action: {
                            // Action for Terms of Service
                            print("Terms of Service action")
                        }) {
                            Text("Terms of Service")
                        }
                    }
                    .padding()
                }
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarHidden(true)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("Color").ignoresSafeArea())
                .alert(isPresented: $showLogoutAlert) {
                    Alert(
                        title: Text("LOGOUT"),
                        message: Text("Are you sure you want to Logout?"),
                        primaryButton: .destructive(
                            Text("Logout"),
                            action: {
                                handleLogout()
                            }
                        ),
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            }
        }

        private func handleLogout() {
            // Reset counts in SharedDataModel
            dataModel.resetCounts()
            
            // Perform any additional logout actions here, such as clearing user sessions
            UserDefaults.standard.set(false, forKey: "log_Status")

            // Update app state to log out
            appState.isLoggedIn = false
        }
    }

    struct DetectionButton: View {
        var title: String
        var description: String
        var backgroundColor: Color

        var body: some View {
            VStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(backgroundColor)
                    .cornerRadius(10)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 5)
            }
            .frame(maxWidth: .infinity) // Ensure buttons take up equal width
        }
    }

    struct MainPageView_Previews: PreviewProvider {
        static var previews: some View {
            MainPageView()
                .environmentObject(SharedDataModel())
                .environmentObject(UserModel())
                .environmentObject(AppState(isLoggedIn: true))
        }
    }
