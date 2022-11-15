//
//  ListEditView.swift
//  Lee
//
//  Created by Mines Student on 11/9/22.
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
            .buttonStyle(.borderless)
            Button {
                minus()
            } label: {
                Image(systemName: "minus")
            }
            .buttonStyle(.borderless)
            Spacer()
        }
    }
}
