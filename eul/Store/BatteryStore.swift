//
//  BatteryStore.swift
//  eul
//
//  Created by Gao Sun on 2020/8/7.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SystemKit

class BatteryStore: ObservableObject, Refreshable {
    static let shared = BatteryStore()

    private var battery = Battery()

    var io = Info.Battery()

    @Published var valid = true

    @Published var acPowered = false
    @Published var charged = false
    @Published var charging = false
    @Published var capacity = 0
    @Published var maxCapacity = 0
    @Published var designCapacity = 0
    @Published var cycleCount = 0

    var charge: Double {
        io.currentCharge
    }

    var health: Double {
        Double(maxCapacity) / Double(designCapacity)
    }

    @objc func refresh() {
        io = Info.Battery()

        guard battery.open() == kIOReturnSuccess else {
            valid = false
            return
        }

        valid = true

        acPowered = battery.isACPowered()
        charged = battery.isCharged()
        charging = battery.isCharging()
        capacity = battery.currentCapacity()
        maxCapacity = battery.maxCapactiy()
        designCapacity = battery.designCapacity()
        cycleCount = battery.cycleCount()
        _ = battery.close()
    }

    init() {
        initObserver(for: .StoreShouldRefresh)
        refresh()
    }
}
