//
//  MKMapView+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/9/9.
//
import MapKit

public extension MKMapView {
    ///缩放级别
    var ld_zoomLevel: Double {
        //获取缩放级别
        get {
            return Double(log2(360 * (Double(self.frame.size.width/256)
                                        / self.region.span.longitudeDelta)) )
        }
        //设置缩放级别
        set (newZoomLevel){
            setCenterCoordinate(coordinate: self.centerCoordinate, zoomLevel: newZoomLevel,
                                animated: true)
        }
    }

    ///根据区域范围、中心设置缩放比例
    func ld_setZoomLevel(geofenceCenter:CLLocationCoordinate2D,range:Double)  {

        let region = MKCoordinateRegion(center: geofenceCenter, latitudinalMeters: range  ,longitudinalMeters: range)
        let zoomLevel = Double(log2(360 * Double(self.frame.size.width/256)
                                        / region.span.longitudeDelta) )
        self.ld_zoomLevel = zoomLevel

    }

    //设置缩放级别时调用
    private func setCenterCoordinate(coordinate: CLLocationCoordinate2D, zoomLevel: Double,
                             animated: Bool){
        let span = MKCoordinateSpan(latitudeDelta: 0, longitudeDelta: 360 / pow(2, Double(zoomLevel)) * Double(self.frame.size.width) / 256)
        setRegion(MKCoordinateRegion(center: centerCoordinate, span: span), animated: animated)
    }
}
