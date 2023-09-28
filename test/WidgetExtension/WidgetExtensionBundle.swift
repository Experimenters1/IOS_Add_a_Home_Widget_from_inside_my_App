//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Huy Vu on 9/28/23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
