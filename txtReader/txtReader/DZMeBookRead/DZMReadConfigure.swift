//
//  DZMReadConfigure.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit



/// 主题颜色
var READ_COLOR_MAIN:UIColor = COLOR_253_85_103

/// 菜单默认颜色
var READ_COLOR_MENU_COLOR:UIColor = COLOR_230_230_230

/// 菜单背景颜色
var READ_COLOR_MENU_BG_COLOR:UIColor = COLOR_46_46_46.withAlphaComponent(0.95)

/// 阅读最小阅读字体大小
let READ_FONT_SIZE_MIN:Int = 2

/// 阅读最大阅读字体大小
let READ_FONT_SIZE_MAX:Int = 24

/// 阅读默认字体大小
let READ_FONT_SIZE_DEFAULT:Int = 18

/// 阅读字体大小叠加指数
let READ_FONT_SIZE_SPACE:Int = 2

/// 章节标题 - 在当前字体大小上叠加指数
let READ_FONT_SIZE_SPACE_TITLE:Int = 8

/// 单利对象
private var configure:DZMReadConfigure?

class DZMReadConfigure: NSObject {
    
    // MARK: 阅读页面配置
    
    /// 开启长按菜单功能 (滚动模式是不支持长按功能的)
    var openLongPress = true
    
    
    // MARK: 阅读内容配置
    
    /// 字体类型索引
    @objc var fontIndex:NSNumber!
    
    /// 翻页类型索引
    @objc var effectIndex:NSNumber!
    
    /// 间距类型索引
    @objc var spacingIndex:NSNumber!
    
    /// 进度显示索引
    @objc var progressIndex:NSNumber!
    
    /// 字体大小
    @objc var fontSize:NSNumber!
    
    
    // MARK: 快捷获取
    
    /// 使用分页进度 || 总文章进度(网络文章也可以使用)
    /// 总文章进度注意: 总文章进度需要有整本书的章节总数,以及当前章节带有从0开始排序的索引。
    /// 如果还需要在拖拽底部功能条上进度条过程中展示章节名,则需要带上章节列表数据,并去 DZMRMProgressView 文件中找到 ASValueTrackingSliderDataSource 修改返回数据源为章节名。
    var progressType:DZMProgressType! { return DZMProgressType(rawValue: progressIndex.intValue) }
    
    /// 翻页类型
    var effectType:DZMEffectType! { return DZMEffectType(rawValue: effectIndex.intValue) }
    
    /// 字体类型
    var fontType:DZMFontType! { return DZMFontType(rawValue: fontIndex.intValue) }
    
    /// 间距类型
    var spacingType:DZMSpacingType! { return DZMSpacingType(rawValue: spacingIndex.intValue) }
    
    /// 背景颜色
    let bgColor = UIColor(patternImage: UIImage(named: "read_bg_0")!)
        
        // 牛皮黄背景
    
    /// 字体颜色
    let textColor = COLOR_145_145_145
     
    /// 状态栏字体颜色
    let statusTextColor = COLOR_145_145_145
        
  
    
    /// 行间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
    var lineSpacing: CGFloat{
        switch spacingType {
        case .big:
            // 大间距
            
            return SPACE_10
        case .middle:
            // 中间距
            
            return SPACE_7
        default:
            // 小间距
            
            return SPACE_5
        }
    
    }
    
    /// 段间距(请设置整数,因为需要比较是否需要重新分页,小数点没法判断相等)
    var paragraphSpacing:CGFloat {
        switch spacingType {
        case .big:
            // 大间距
            
            return SPACE_20
        case .middle:
            // 中间距
            
            return SPACE_15
        default:
            // 小间距
            
            return SPACE_10
        }
    }
    
    /// 阅读字体
    func font(isTitle:Bool = false) ->UIFont {
        
        let size = SA_SIZE(CGFloat(fontSize.intValue + (isTitle ? READ_FONT_SIZE_SPACE_TITLE : 0)))
        
        let fontType = self.fontType
        switch fontType {
        case .one:
            // 黑体
            return UIFont(name: "EuphemiaUCAS-Italic", size: size)!
        case .two:
            // 楷体
            return UIFont(name: "AmericanTypewriter-Light", size: size)!
        case .three:
            // 宋体
            return UIFont(name: "Papyrus", size: size)!
        default:
            // 系统
            return UIFont.systemFont(ofSize: size)
        }
      
    }
    
    /// 字体属性
    /// isPaging: 为YES的时候只需要返回跟分页相关的属性即可 (原因:包含UIColor,小数点相关的...不可返回,因为无法进行比较)
    func attributes(isTitle:Bool, isPageing:Bool = false) ->[NSAttributedString.Key: Any] {
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = 1.0
        
        if isTitle {
            
            // 行间距
            paragraphStyle.lineSpacing = 0
            
            // 段间距
            paragraphStyle.paragraphSpacing = 0
            
            // 对齐
            paragraphStyle.alignment = .center
            
        }else{
            
            // 行间距
            paragraphStyle.lineSpacing = lineSpacing
            
            // 段间距
            paragraphStyle.paragraphSpacing = paragraphSpacing
            
            // 对齐
            paragraphStyle.alignment = .justified
        }
        
        if isPageing {
            
            return [.font: font(isTitle: isTitle), .paragraphStyle: paragraphStyle]
            
        }else{
            
            return [.foregroundColor: textColor, .font: font(isTitle: isTitle), .paragraphStyle: paragraphStyle]
        }
    }
    
    
    // MARK: 辅助
    
    /// 保存(使用 DZMUserDefaults 存储是方便配置修改)
    func save() {
        
        let dict = ["fontIndex": fontIndex,
                    "effectIndex": effectIndex,
                    "spacingIndex": spacingIndex,
                    "progressIndex": progressIndex,
                    "fontSize": fontSize]
    
        DZMUserDefaults.setObject(dict, READ_KEY_CONFIGURE)
    }
    
    
    // MARK: 构造
    
    /// 获取对象
    static var shared: DZMReadConfigure {
        
        if configure == nil { configure = DZMReadConfigure(DZMUserDefaults.object(READ_KEY_CONFIGURE)) }
        
        return configure!
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
  
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
        

    /// 初始化配置数据,以及处理初始化数据的增删

        
        // 字体类型
        if (fontIndex == nil) || (DZMFontType(rawValue: fontIndex.intValue) == nil) {
            
            fontIndex = NSNumber(value: DZMFontType.two.rawValue)
        }
        
        // 间距类型
        if (spacingIndex == nil) || (DZMSpacingType(rawValue: spacingIndex.intValue) == nil) {
            
            spacingIndex = NSNumber(value: DZMSpacingType.small.rawValue)
        }
        
        // 翻页类型
        if (effectIndex == nil) || (DZMEffectType(rawValue: effectIndex.intValue) == nil) {
            
            effectIndex = NSNumber(value: DZMEffectType.simulation.rawValue)
        }
        
        // 字体大小
        if (fontSize == nil) || (fontSize.intValue > READ_FONT_SIZE_MAX || fontSize.intValue < READ_FONT_SIZE_MIN) {
            
            fontSize = NSNumber(value: READ_FONT_SIZE_DEFAULT)
        }
        
        // 显示进度类型
        if (progressIndex == nil) || (DZMProgressType(rawValue: progressIndex.intValue) == nil) {
            
            progressIndex = NSNumber(value: DZMProgressType.page.rawValue)
        }
    }
    
    class func model(_ dict:Any?) ->DZMReadConfigure {
        return DZMReadConfigure(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
