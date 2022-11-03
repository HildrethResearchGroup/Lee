//
//  ListEditView.swift
//  Lee
//
//  Created by Mines Student on 11/1/22.
//

import Foundation
import SwiftUI

struct ListEditView: View {
    let plus: () -> Void
    let minus: () -> Void
    
    var body: some View {
        HStack {
            Button {
                plus()
            } label: {
                Image(systemName: "plus")
            }
            Button {
                minus()
            } label: {
                Image(systemName: "minus")
            }
            Spacer()
        }
        .padding(4)
    }
}
