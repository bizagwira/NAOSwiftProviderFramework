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
    public var onLocationAvailable:((_ latitude: Float, _ longitude: Float, _ altitude: Int) -> ())?
    public var onLocationStatusChanged:((_ statusString: String) -> ())?
    
    required public init(apikey: String) {
        super.init(apikey: apikey)
        
        self.locationHandle = NAOLocationHandle(key: apikey, delegate: self, sensorsDelegate: self)
        self.locationHandle?.synchronizeData(self)
    }
    
    override public func start() {
        if (!self.status){
            self.locationHandle?.start()
        }
        self.status = true
    }
    
    override public func stop() {
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
        switch (status) {
            case DBTNAOFIXSTATUS.NAO_FIX_UNAVAILABLE:
                onLocationStatusChanged?("LOCATION STATUS: FIX_UNAVAILABLE")
                break;
            case DBTNAOFIXSTATUS.NAO_FIX_AVAILABLE:
                onLocationStatusChanged?("LOCATION STATUS: UNAVAILABLE")
                break;
            case DBTNAOFIXSTATUS.NAO_TEMPORARY_UNAVAILABLE:
                onLocationStatusChanged?("LOCATION STATUS: TEMPORARY_UNAVAILABLE")
                break;
            case DBTNAOFIXSTATUS.NAO_OUT_OF_SERVICE:
                onLocationStatusChanged?("LOCATION STATUS: OUT_OF_SERVICE")
                break;
            default:
                onLocationStatusChanged?("LOCATION STATUS: UNKNOWN")
                break;
        }
    }

    public func didFailWithErrorCode(_ errCode: DBNAOERRORCODE, andMessage message: String!) {
        ServiceProvider.onErrorEventWithErrorCode?("NAOLocationHandle fails: \(String(describing: message)) with error code \(errCode)")
    }

    deinit {
        print("LocationProvider deinitialized")
    }
}
