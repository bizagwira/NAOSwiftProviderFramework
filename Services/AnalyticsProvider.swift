//
//  AnalyticsProvider.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 16/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule

public class AnalyticsProvider: ServiceProvider, NAOAnalyticsHandleDelegate {
    
     var analyticHandler: NAOAnalyticsHandle? = nil
    
     required init(apikey: String) {
         super.init(apikey: apikey)
         
         self.analyticHandler = NAOAnalyticsHandle(key: apikey, delegate: self, sensorsDelegate: self)
         self.analyticHandler?.synchronizeData(self)
     }
     
     override func start() {
         if (!self.status){
             self.analyticHandler?.start()
         }
         self.status = true
     }
     
     override func stop() {
         if (self.status){
             self.analyticHandler?.stop()
         }
         self.status = false
     }
     
     // MARK: - NAOAnalyticsHandleDelegate
     public func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
        ServiceProvider.onErrorEventWithErrorCode?(errCode, "Analytics' error: \(String(describing: message))")
     }
     
     deinit {
         print("AnalyticsProvider deinitialized")
     }
}
