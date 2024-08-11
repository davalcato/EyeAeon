//
//  Detection.swift
//  Pods
//
//  Created by Ethan Hunt on 8/10/24.
//

//import SwiftUI
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//
//struct Detection: Identifiable, Codable {
//    var id: String? // No need for @DocumentID here
//    let type: String
//    let success: Bool
//    let timestamp: Timestamp
//    
//    init(id: String? = nil, type: String, success: Bool, timestamp: Timestamp) {
//        self.id = id
//        self.type = type
//        self.success = success
//        self.timestamp = timestamp
//    }
//    
//    // Custom initializer to decode from Firestore DocumentSnapshot
//    init?(document: DocumentSnapshot) {
//        let data = document.data()
//        guard let type = data?["type"] as? String,
//              let success = data?["success"] as? Bool,
//              let timestamp = data?["timestamp"] as? Timestamp else {
//            return nil
//        }
//        
//        self.id = document.documentID
//        self.type = type
//        self.success = success
//        self.timestamp = timestamp
//    }
//}

