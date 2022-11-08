//
//  Extensions.swift
//  WhatMovieToWatchZ
//
//  Created by Sofyan Zarouri on 23/08/2022 
//  Copyright © 2022 Sofyan Zarouri. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var safeAreaFrame: CGRect {
        if #available(iOS 11, *) {
            return safeAreaLayoutGuide.layoutFrame
        }
        return bounds
    }
}
