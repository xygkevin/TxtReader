//
//  ReadViewController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class ReadViewController: DZMViewController {
    
    
    
    // 需要两个对象， 当前页阅读记录 和 阅读对象
    
    /// 当前页阅读记录对象
    var recordModel:DZMReadRecordModel!

    /// 阅读对象  (  用于显示书名以及书籍首页显示书籍信息  )
    weak var readModel:DZMReadModel!
    
    /// 顶部状态栏
    var topView:DZMReadViewStatusTopView!
    
    /// 底部状态栏
    var bottomView:DZMReadViewStatusBottomView!
    
    /// 阅读视图
    private var readView:DZMReadView!
    
    /// 书籍首页视图
    private var homeView:DZMReadHomeView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 设置阅读背景
        view.backgroundColor = DZMReadConfigure.shared.bgColor
        
        // 刷新阅读进度
        
        addSubviews()
        reloadProgress()
    }
    
    func addSubviews() {
        
        // 阅读使用范围
        let readRect = READ_RECT
        
        // 顶部状态栏
        topView = DZMReadViewStatusTopView()
        topView.bookName.text = readModel.bookName
        topView.chapterName.text = recordModel.chapterModel.name
        view.addSubview(topView)
        topView.frame = CGRect(x: readRect.minX, y: readRect.minY, width: readRect.width, height: READ_STATUS_TOP_VIEW_HEIGHT)
        
        // 底部状态栏
        bottomView = DZMReadViewStatusBottomView()
        view.addSubview(bottomView)
        bottomView.frame = CGRect(x: readRect.minX, y: readRect.maxY - READ_STATUS_BOTTOM_VIEW_HEIGHT, width: readRect.width, height: READ_STATUS_BOTTOM_VIEW_HEIGHT)
        
        // 阅读视图
        initReadView()
    }
    
    /// 初始化阅读视图
    func initReadView() {
        
        // 是否为书籍首页
        if recordModel.pageModel.isHomePage {
            
            topView.isHidden = true
            bottomView.isHidden = true
            
            homeView = DZMReadHomeView()
            homeView.readModel = readModel
            view.addSubview(homeView)
            homeView.frame = READ_VIEW_RECT
            
        }else{
            
            readView = DZMReadView()
            readView.content = recordModel.contentAttributedString
            view.addSubview(readView)
            readView.frame = READ_VIEW_RECT
        }
    }
    
    /// 刷新阅读进度显示
    private func reloadProgress() {
        switch DZMReadConfigure.shared.progressType {
        case .total:
            // 总进度
             
             // 当前阅读进度
             let progress:Float = readModel.progress(readTotal: recordModel)
            
             // 显示进度
             bottomView.progress.text = progress.readTotalProgress
        default:
            // 分页进度
            
            // 显示进度
            bottomView.progress.text = "\(recordModel.page.intValue + 1)/\(recordModel.chapterModel!.pageCount.intValue)"
        }
    }
    

}
