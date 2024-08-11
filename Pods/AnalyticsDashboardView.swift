//
//  AnalyticsDashboardView.swift
//  Pods
//
//  Created by Ethan Hunt on 8/7/24.
//

import SwiftUI
import FirebaseFirestore

struct AnalyticsDashboardView: View {
    @State private var detections: [Detection] = []

    var body: some View {
        VStack {
            Text("Analytics Dashboard")
                .font(.largeTitle)
                .padding()

            List(detections) { detection in
                HStack {
                    Text(detection.type)
                    Spacer()
                    Text(detection.success ? "Success" : "Failure")
                }
            }
        }
        .onAppear {
            fetchData()
        }
    }

    private func fetchData() {
        let db = Firestore.firestore()
        db.collection("detections").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error)")
            } else {
                self.detections = snapshot?.documents.compactMap {
                    try? $0.data(as: Detection.self)
                } ?? []
            }
        }
    }
}

struct Detection: Identifiable, Codable {
    @DocumentID var id: String?
    let type: String
    let success: Bool
    let timestamp: Timestamp
}

struct AnalyticsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsDashboardView()
    }
}


#Preview {
    AnalyticsDashboardView()
}
