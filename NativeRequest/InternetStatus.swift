//
//  InternetStatus.swift
//  NativeRequest
//
//  Created by DISMOV on 13/05/22.
//

import Network

enum InternetType{
    case none
    case wifi
    case cellular
}

class InternetStatus: NSObject {
    
    static let instance = InternetStatus()
    private override init() {
        super.init()
        monitoring()
    }
    
    var internetType: InternetType = .none
    
    private func monitoring() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status != .satisfied {
                self.internetType = .none
            }
            else {
                //if path.usesInterfaceType(.wifi) {
                if path.usesInterfaceType(.wiredEthernet) {
                    self.internetType = .wifi
                }
                else if path.usesInterfaceType(.cellular) {
                    self.internetType = .cellular
                }
            }
        }
        // El queue global, se utiliza para ejecutar cualquier cosa en background mientras no necesitemos mayores recursos
        monitor.start(queue: DispatchQueue.global())
    }
    
}
