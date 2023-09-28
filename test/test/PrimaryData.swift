//
//  PrimaryData.swift
//  test
//
//  Created by Huy Vu on 9/28/23.
//

import SwiftUI
import WidgetKit

struct  PrimaryData {
    @AppStorage("CreateWiget",store: UserDefaults(suiteName: "group.huy.test1")) var primaryData : Data = Data()
    
    let storeData : StoreData
    func encodeData(){
        guard let data =  try? JSONEncoder().encode(storeData) else {
           return
        }
        primaryData  = data
        WidgetCenter.shared.reloadAllTimelines()
    }
}


