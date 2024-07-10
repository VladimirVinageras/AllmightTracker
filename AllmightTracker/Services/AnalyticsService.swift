//
//  AnalyticsService.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 08.07.2024.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "6bbe5134-2506-4f1b-b7ca-e767df00433c") else {
            return
        }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    func didTapCellPlusButton(){
        report(event: "click", params: ["screen": "Main", "item": "track"])
    }
    func mainScreenDidAppear(){
        report(event: "open", params: ["screen": "Main"])
    }
    
    func mainScreenDidPlusButtonTap(){
        report(event: "click", params: ["screen": "Main", "item": "add_track"])
    }
    
    func mainScreenDidDisappear(){
        report(event: "close", params: ["screen": "Main"])
    }
    
    func mainScreenDidFilterButtonTap(){
        report(event: "click", params: ["screen": "Main", "item": "filter"])
    }
    
    func mainScreenContextualMenuDidEditTap(){
        report(event: "click", params: ["screen": "Main", "item": "edit"])
    }
    
    func mainScreenContextualMenuDidDeleteTap(){
        report(event: "click", params: ["screen": "Main", "item": "delete"])
    }
}
