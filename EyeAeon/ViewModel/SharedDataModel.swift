//
//  SharedDataModel.swift
//  EyeAeon
//
//  Created by Ethan Hunt on 7/23/24.
//

import SwiftUI

class SharedDataModel: ObservableObject {
    @Published var imageCount: Int = 0
    @Published var videoCount: Int = 0
    @Published var audioCount: Int = 0

    func incrementImageCount() {
        imageCount += 1
    }

    func incrementVideoCount() {
        videoCount += 1
    }

    func incrementAudioCount() {
        audioCount += 1
    }
    
    func resetCounts() {
        imageCount = 0
        videoCount = 0
        audioCount = 0
    }
}

struct SharedDataModel_Previews: PreviewProvider {
    static var previews: some View {
        MainPageView()
            .environmentObject(SharedDataModel())
    }
}

