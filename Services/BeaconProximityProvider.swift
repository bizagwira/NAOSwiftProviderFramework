//
//  BeaconProximityProvider.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 16/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule


class BeaconProximityProvider: ServiceProvider, NAOBeaconProximityHandleDelegate {

    var beaconProximityHandler: NAOBeaconProximityHandle? = nil
    
    // Callbacks declarations
    var onRangeBeaconEvent:((_ beaconPublicID: String, _ rssi: Int32) -> ())?
    var onProximityChangeEvent:((_ proximity: DBTBEACONSTATE, _ beaconPublicID: String?) -> ())?
    
     required init(apikey: String) {
         super.init(apikey: apikey)
         
         self.beaconProximityHandler = NAOBeaconProximityHandle(key: apikey, delegate: self, sensorsDelegate: self)
         self.beaconProximityHandler?.synchronizeData(self)
     }
     
     override func start() {
         if (!self.status){
             self.beaconProximityHandler?.start()
         }
         self.status = true
     }
     
     override func stop() {
         if (self.status){
             self.beaconProximityHandler?.stop()
         }
         self.status = false
     }
     
    // MARK: - NAOBeaconProximityHandleDelegate
    func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
        ServiceProvider.onErrorEventWithErrorCode?(errCode, message)
    }

    func didRangeBeacon(_ beaconPublicID: String!, withRssi rssi: Int32) {
        onRangeBeaconEvent!(beaconPublicID, rssi)
    }
    
    func didProximityChange(_ proximity: DBTBEACONSTATE, forBeacon beaconPublicID: String!) {
        onProximityChangeEvent!(proximity, beaconPublicID)
    }

    deinit {
        print("BeaconProximityProvider deinitialized")
    }
}
