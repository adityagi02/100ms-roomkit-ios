//
//  ImageExtension.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 30/06/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI

extension Image {
    init(assetName: String) {
        self.init(assetName, bundle: Bundle(identifier:"live.100ms.HMS.RoomKit"))
        self = self.renderingMode(.template)
    }
}

extension Color {
    init(assetName: String) {
        self.init(assetName, bundle: Bundle(identifier:"live.100ms.HMS.RoomKit"))
    }
}
