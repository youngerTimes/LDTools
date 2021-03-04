//
//  AVURLAsset+LDExtension.swift
//  LDTools-Swift
//
//  Created by 无故事王国 on 2021/3/4.
//

import AVKit

public extension AVURLAsset{
    ///获取视频截图(网络)
    func jq_GetVedioPicture(_ image: ((_ vedioImage:UIImage)->Void)?) {
        DispatchQueue.global().async {
            //生成视频截图
            let generator = AVAssetImageGenerator(asset: self)
            generator.appliesPreferredTrackTransform = true
            let time = CMTimeMakeWithSeconds(0.0,preferredTimescale: 600)
            var actualTime:CMTime = CMTimeMake(value: 0,timescale: 0)
            do {
                let imageRef:CGImage = try generator.copyCGImage(at: time, actualTime: &actualTime)
                let frameImg = UIImage(cgImage: imageRef)
                DispatchQueue.main.async(execute: {
                    if (image) != nil {
                        image!(frameImg)
                    }
                })
            }catch {
                print(error)
            }
        }
    }
}
