//
//  View Extensions.swift
//  Pixel Desktop Pictures
//
//  Created by Kavinda Dilshan on 2024-12-22.
//

import SwiftUICore

extension View {
    // MARK: - Set Tab Content Height To Tabs ViewModel
    func setTabContentHeightToTabsViewModel(vm tabsVM: TabsViewModel) -> some View {
        return self
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            tabsVM.setTabContentHeight(geo.size.height)
                        }
                }
                
            }
    }
}
