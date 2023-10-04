//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Huy Vu on 10/3/23.
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
