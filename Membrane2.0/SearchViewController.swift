//
//  RoomSelectionViewController.swift
//  Membrane2.0
//
//  Created by Fedor Bebinov on 22.08.2023.
//

import UIKit
import CoreBluetooth

class SearchViewController: UIViewController{
    
    var centralManager: CBCentralManager!
    var  peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    var devices = [CBPeripheral]()
    
    private lazy var devicesCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var devicesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        devicesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        devicesCollectionView.dataSource = self
        devicesCollectionView.register(DeviceCollectionViewCell.self, forCellWithReuseIdentifier: "DeviceCollectionViewCell")
        devicesCollectionView.delegate = self
        return devicesCollectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        view.backgroundColor = .clear
        
        view.addSubview(devicesCollectionView)
        NSLayoutConstraint.activate([devicesCollectionView.topAnchor.constraint(equalTo: view.topAnchor), devicesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), devicesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), devicesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
    }
    

    func findSecondDevice(){
        //centralManager.scanForPeripherals(withServices: [Device.serviceUUID])
        centralManager.scanForPeripherals(withServices: nil)
    }
    
    func send(message: TouchMessage){
        guard let peripheral = peripheral else{
            return
        }
        guard let characteristic = characteristic else {
            return
        }
        let encoder = JSONEncoder()
        do{
            let data = try encoder.encode(message)
            peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
        } catch {
            print(error)
        }
        
    }

}
extension SearchViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch centralManager.state {
        case .poweredOn:
            print("poweredOn")
            findSecondDevice()
        case .poweredOff:
            print("poweredOff")
        default:
            print("default")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print(peripheral.name ?? "unknown")
        if !devices.contains(where: {$0.identifier == peripheral.identifier}){
            devices.append(peripheral)
            devicesCollectionView.reloadData()
        }
       // centralManager.connect(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        centralManager.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([Device.serviceUUID])
        self.peripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
    }
}

extension SearchViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            return
        }
        for service in services {
            peripheral.discoverCharacteristics([Device.characteristicUUID], for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            return
        }
        let filteredCharacteristic = characteristics.first { characteristic in
            characteristic.uuid == Device.characteristicUUID
        }
        print(filteredCharacteristic!)
        self.characteristic = filteredCharacteristic
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let valueData = characteristic.value else{
            return
        }
        let decoder = JSONDecoder()
        do {
            let touchMessage = try decoder.decode(TouchMessage.self, from: valueData)
            print(touchMessage.text)
        } catch {
            print(error)
        }
    }
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCollectionViewCell", for: indexPath) as! DeviceCollectionViewCell
        cell.backgroundColor = .orange
        cell.nameLabel.text = devices[indexPath.row].name ?? "unknown"
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = devicesCollectionView.frame.width - 32 - 8
        return CGSize(width: width / 2, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
