//
//  Device.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 22.08.2023.
//

import Foundation
import CoreBluetooth

struct Device {
    static let serviceUUID = CBUUID(string: "E20A39F4-73F5-4BC4-A12F-17D1AD07A961")
    static let characteristicUUID = CBUUID(string: "08590F7E-DB05-467E-8757-72F6FAEB13D4")
}
