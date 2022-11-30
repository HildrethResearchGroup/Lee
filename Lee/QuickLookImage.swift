//
//  QuickLookImage.swift
//  Lee
//
//  Created by Davita Bird on 11/17/22.
//
import SwiftUI
import Quartz

//Creating struct to display output files
struct QLImage: NSViewRepresentable {
    var url: URL
    
    func makeNSView(context: NSViewRepresentableContext<QLImage>) -> QLPreviewView {
        let preview = QLPreviewView(frame: .zero, style: .normal)
        preview?.autostarts = true
        preview?.previewItem = url as QLPreviewItem
        
        return preview ?? QLPreviewView()
    }
    
    func updateNSView(_ nsView: QLPreviewView, context: NSViewRepresentableContext<QLImage>) {
        nsView.previewItem = url as QLPreviewItem
    }
    
    typealias NSViewType = QLPreviewView
}
