//
//  DZMFontList.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// Font Size List
let FONT_SIZE_8:CGFloat = 8
let FONT_SIZE_9:CGFloat = 9
let FONT_SIZE_10:CGFloat = 10
let FONT_SIZE_11:CGFloat = 11
let FONT_SIZE_12:CGFloat = 12
let FONT_SIZE_13:CGFloat = 13
let FONT_SIZE_14:CGFloat = 14
let FONT_SIZE_15:CGFloat = 15
let FONT_SIZE_16:CGFloat = 16
let FONT_SIZE_17:CGFloat = 17
let FONT_SIZE_18:CGFloat = 18
let FONT_SIZE_19:CGFloat = 19
let FONT_SIZE_20:CGFloat = 20
let FONT_SIZE_21:CGFloat = 21
let FONT_SIZE_22:CGFloat = 22
let FONT_SIZE_23:CGFloat = 23
let FONT_SIZE_24:CGFloat = 24
let FONT_SIZE_25:CGFloat = 25
let FONT_SIZE_26:CGFloat = 26
let FONT_SIZE_29:CGFloat = 29
let FONT_SIZE_30:CGFloat = 30

let FONT_SIZE_SA_8:CGFloat = SA_SIZE(FONT_SIZE_8)
let FONT_SIZE_SA_9:CGFloat = SA_SIZE(FONT_SIZE_9)
let FONT_SIZE_SA_10:CGFloat = SA_SIZE(FONT_SIZE_10)
let FONT_SIZE_SA_11:CGFloat = SA_SIZE(FONT_SIZE_11)
let FONT_SIZE_SA_12:CGFloat = SA_SIZE(FONT_SIZE_12)
let FONT_SIZE_SA_13:CGFloat = SA_SIZE(FONT_SIZE_13)
let FONT_SIZE_SA_14:CGFloat = SA_SIZE(FONT_SIZE_14)
let FONT_SIZE_SA_15:CGFloat = SA_SIZE(FONT_SIZE_15)
let FONT_SIZE_SA_16:CGFloat = SA_SIZE(FONT_SIZE_16)
let FONT_SIZE_SA_17:CGFloat = SA_SIZE(FONT_SIZE_17)
let FONT_SIZE_SA_18:CGFloat = SA_SIZE(FONT_SIZE_18)
let FONT_SIZE_SA_19:CGFloat = SA_SIZE(FONT_SIZE_19)
let FONT_SIZE_SA_20:CGFloat = SA_SIZE(FONT_SIZE_20)
let FONT_SIZE_SA_21:CGFloat = SA_SIZE(FONT_SIZE_21)
let FONT_SIZE_SA_22:CGFloat = SA_SIZE(FONT_SIZE_22)
let FONT_SIZE_SA_23:CGFloat = SA_SIZE(FONT_SIZE_23)
let FONT_SIZE_SA_24:CGFloat = SA_SIZE(FONT_SIZE_24)
let FONT_SIZE_SA_25:CGFloat = SA_SIZE(FONT_SIZE_25)
let FONT_SIZE_SA_26:CGFloat = SA_SIZE(FONT_SIZE_26)
let FONT_SIZE_SA_29:CGFloat = SA_SIZE(FONT_SIZE_29)
let FONT_SIZE_SA_30:CGFloat = SA_SIZE(FONT_SIZE_30)

/// Font List
let FONT_SA_10 = FONT(FONT_SIZE_SA_10)
let FONT_SA_12 = FONT(FONT_SIZE_SA_12)
let FONT_SA_14 = FONT(FONT_SIZE_SA_14)
let FONT_SA_15 = FONT(FONT_SIZE_SA_15)
let FONT_SA_16 = FONT(FONT_SIZE_SA_16)
let FONT_SA_18 = FONT(FONT_SIZE_SA_18)
func FONT(_ size:CGFloat) ->UIFont { return UIFont.systemFont(ofSize: size) }
func FONT_SA(_ size:CGFloat) ->UIFont { return UIFont.systemFont(ofSize: SA_SIZE(size)) }

let FONT_BOLD_SA_16 = FONT_BOLD(FONT_SIZE_SA_16)
func FONT_BOLD(_ size:CGFloat) ->UIFont { return UIFont.boldSystemFont(ofSize: size) }
func FONT_BOLD_SA(_ size:CGFloat) ->UIFont { return UIFont.boldSystemFont(ofSize: SA_SIZE(size)) }
