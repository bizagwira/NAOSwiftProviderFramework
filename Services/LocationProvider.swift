//
//  LocationProvider.swift
//  NaoSdkSwiftApiClient
//
//  Created by Pole Star on 15/01/2020.
//  Copyright © 2020 Pole Star. All rights reserved.
//

import UIKit
import NAOSDKModule

public class LocationProvider: ServiceProvider, NAOLocationHandleDelegate {
    
    var locationHandle: NAOLocationHandle? = nil
    
    // Callbacks declarations
    var onLocationAvailable:((_ latitude: Float, _ longitude: Float, _ altitude: Int) -> ())?
    var onLocationStatusChanged:((_ status: DBTNAOFIXSTATUS) -> ())?
    
    required init(apikey: String) {
        super.init(apikey: apikey)
        
        self.locationHandle = NAOLocationHandle(key: apikey, delegate: self, sensorsDelegate: self)
        self.locationHandle?.synchronizeData(self)
    }
    
    override func start() {
        if (!self.status){
            self.locationHandle?.start()
        }
        self.status = true
    }
    
    override func stop() {
        if (self.status){
            self.locationHandle?.stop()
        }
        self.status = false
    }
    
    // MARK: - NAOLocationHandleDelegate --
     
    public func didEnterSite (_ name: String){
        //Post the didEnterSite notification
        NotificationCenter.default.post(name: NSNotification.Name("notifyEnterSite"), object: nil)
    }

    public func didExitSite (_ name: String){
        //Post the didExitSite notification
        NotificationCenter.default.post(name: NSNotification.Name("notifyExitSite"), object: nil)
    }

    public func didLocationChange(_ location: CLLocation!) {
        let latitude = (location.coordinate.latitude.description as NSString).floatValue
        let longitude = (location.coordinate.longitude.description as NSString).floatValue
        let altitude = Int(location!.altitude as Double)
        // Send the location through the callback
        onLocationAvailable?(latitude, longitude, altitude)
    }

    public func didLocationStatusChanged(_ status: DBTNAOFIXSTATUS) {
        onLocationStatusChanged?(status)
    }

    public func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
        ServiceProvider.onErrorEventWithErrorCode?(errCode, message)
    }

    deinit {
        print("LocationProvider deinitialized")
    }
}
