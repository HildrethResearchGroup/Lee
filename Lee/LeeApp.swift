//
//  LeeApp.swift
//  Lee
//
//  Created by Mines Student on 8/30/22.
//

import Foundation

//this is the VIEWMODEL
//needs to be published and content view needs to subscribe to it

class LeeApp: ObservableObject {
    @Published private var model = LeeDataModel()
    
   
    //intent function for when user chooses manifest file through view
    
    func saveFile(_ filename: String){
        model.manifestFilename = filename
    }
    

}
