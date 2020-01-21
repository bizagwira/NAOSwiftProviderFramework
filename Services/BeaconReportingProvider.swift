//
//  BeaconReportingProvider.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 16/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule

public class BeaconReportingProvider: ServiceProvider, NAOBeaconReportingHandleDelegate {
    
     var beaconReportingHandler: NAOBeaconReportingHandle? = nil
    
     required init(apikey: String) {
         super.init(apikey: apikey)
         
         self.beaconReportingHandler = NAOBeaconReportingHandle(key: apikey, delegate: self, sensorsDelegate: self)
         self.beaconReportingHandler?.synchronizeData(self)
     }
     
     override func start() {
         if (!self.status){
             self.beaconReportingHandler?.start()
         }
         self.status = true
     }
     
     override func stop() {
         if (self.status){
             self.beaconReportingHandler?.stop()
         }
         self.status = false
     }
     
     // MARK: - NAOBeaconReportingHandleDelegate
     public func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
       ServiceProvider.onErrorEventWithErrorCode?(errCode, "Beacon reporting error: \(String(describing: message))")
     }
     
     deinit {
         print("BeaconReportingProvider deinitialized")
     }
}
