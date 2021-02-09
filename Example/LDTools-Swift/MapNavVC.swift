//
//  MapNavVC.swift
//  LDTools-Swift_Example
//
//  Created by 无故事王国 on 2021/2/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import CoreLocation

class MapNavVC: LD_BaseVC{

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white


        LD_LocationTool.default.startHeading { (heading,angle)  in
            print("\(heading)----\(angle)")
        } errorClouse: { (error) in
            print(error.localizedDescription)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+3) {

        }

        LD_MapNavigationTool.startNav(CLLocationCoordinate2D(latitude: 30.500728, longitude: 104.088798), distanceName:"终点" , scheme: "acb")
    }


    deinit {

    }
}
