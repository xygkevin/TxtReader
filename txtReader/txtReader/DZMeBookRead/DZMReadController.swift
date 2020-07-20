//
//  DZMReadController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadController: DZMViewController{

    // MARK: 数据相关
    
    /// 阅读对象
    var readModel:DZMReadModel!
    
    
    // MARK: UI相关
    
    /// 阅读主视图
    var contentView = DZMReadContentView()
    
    /// 章节列表
    var leftView = DZMReadLeftView()
    
    /// 阅读菜单
    // 初始化菜单
    lazy var readMenu = DZMReadMenu(vc: self, delegate: self)
    
    /// 翻页控制器 (仿真)
    var pageViewController:UIPageViewController!
    
    /// 翻页控制器 (滚动)
    var scrollController:DZMReadViewScrollController!
    
    /// 翻页控制器 (无效果,覆盖)
    var coverController:DZMCoverController!
    
    /// 非滚动模式时,当前显示 ReadViewController
    var currentDisplayController:ReadViewController?
    
    /// 用于区分正反面的值(勿动)
    
    var tempNumber = 1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 初始化书籍阅读记录
        if let record = readModel.recordModel{
            update(read: record)
        }
        
        // 隐藏导航栏
        fd_prefersNavigationBarHidden = true
        
        // 禁止手势返回
        fd_interactivePopDisabled = true
        // 背景颜色
        view.backgroundColor = DZMReadConfigure.shared.bgColor
        
        // 初始化控制器
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
        
        // 监控阅读长按视图通知
        monitorReadLongPressView()
        addSubviews()
    }
    


    func addSubviews(){
        
        // 目录侧滑栏
        leftView.catalogView.readModel = readModel
        leftView.catalogView.delegate = self
        leftView.markView.readModel = readModel
        leftView.markView.delegate = self
        
        view.addSubview(leftView)
        leftView.frame = CGRect(x: -READ_LEFT_VIEW_WIDTH, y: 0, width: READ_LEFT_VIEW_WIDTH, height: ScreenHeight)
        
        // 阅读视图
        
        contentView.delegate = self
        view.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
    }
    
    // MARK: 监控阅读长按视图通知
    
    // 监控阅读长按视图通知
    private func monitorReadLongPressView() {
        
        if DZMReadConfigure.shared.openLongPress {
            
            READ_NOTIFICATION_MONITOR(target: self, action: #selector(longPressViewNotification(notification:)))
        }
    }
    
    // 处理通知
    @objc private func longPressViewNotification(notification:Notification) {
        
        // 获得状态
        let info = notification.userInfo
        
        // 隐藏菜单
        readMenu.showMenu(isShow: false)
        
        // 解析状态
        if let dict = info , dict.keys.contains(READ_KEY_LONG_PRESS_VIEW), let isOpen = dict[READ_KEY_LONG_PRESS_VIEW] as? NSNumber{
            coverController?.gestureRecognizerEnabled = isOpen.boolValue
            
            pageViewController?.gestureRecognizerEnabled = isOpen.boolValue
            
            readMenu.singleTap.isEnabled = isOpen.boolValue
        }
    }
    
    
    
    deinit {
        
        // 移除阅读长按视图监控
        READ_NOTIFICATION_REMOVE(target: self)
        
        // 清理阅读控制器
        clearPageController()
    }
}



extension DZMReadController: DZMReadCatalogViewDelegate{
 
    
    // MARK: DZMReadCatalogViewDelegate
    
    /// 章节目录选中章节
    func catalogViewClickChapter(catalogView: DZMReadCatalogView, chapterListModel: DZMReadChapterListModel) {
        
        showLeftView(isShow: false)
        
        contentView.showCover(isShow: false)
        
        guard let record = readModel.recordModel, record.chapterModel.id != chapterListModel.id  else { return }
        
        goToChapter(chapterID: chapterListModel.id)
    }
 
}



    // MARK: DZMReadMarkViewDelegate
extension DZMReadController: DZMReadMarkViewDelegate{
    /// 书签列表选中书签
    func markViewClickMark(markView: DZMReadMarkView, markModel: DZMReadMarkModel) {
        
        showLeftView(isShow: false)
        
        contentView.showCover(isShow: false)
        
        goToChapter(chapterID: markModel.chapterID, location: markModel.location.intValue)
    }
}
    



extension DZMReadController: DZMReadContentViewDelegate{
    // MARK: DZMReadContentViewDelegate
    
    /// 点击遮罩
    func contentViewClickCover(contentView: DZMReadContentView) {
        
        showLeftView(isShow: false)
    }
}
    
    
extension DZMReadController: DZMReadMenuDelegate{
    
    // MARK: DZMReadMenuDelegate
    
    /// 菜单将要显示
    func readMenuWillDisplay(readMenu: DZMReadMenu!) {
        
        // 检查当前内容是否包含书签
        readMenu.topView.checkForMark()
        
        // 刷新阅读进度
        readMenu.bottomView.progressView.reloadProgress()
    }
    
    /// 点击返回
    func readMenuClickBack(readMenu: DZMReadMenu!) {
        
        // 清空坐标
        Sand.readRecordCurrentChapterLocation = nil
        
        // 返回
        navigationController?.popViewController(animated: true)
    }
    
    /// 点击书签
    func readMenuClickMark(readMenu: DZMReadMenu!, topView: DZMRMTopView!, markButton: UIButton!) {
        
        markButton.isSelected = !markButton.isSelected
        
        if markButton.isSelected { readModel.insetMark()
            
        }else{ readModel.removeMark() }
        
        topView.updateMarkButton()
    }
    
    /// 点击目录
    func readMenuClickCatalogue(readMenu:DZMReadMenu!) {
        
        showLeftView(isShow: true)
        
        contentView.showCover(isShow: true)
        
        readMenu.showMenu(isShow: false)
    }
    

    
    /// 点击上一章
    func readMenuClickPreviousChapter(readMenu: DZMReadMenu!) {
        let first = readModel.recordModel?.isFirstChapter
        if first.ok{
            
            DZMLog("已经是第一章了")
            
        }else if let record = readModel.recordModel{
            
            goToChapter(chapterID: record.chapterModel.previousChapterID)
            
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
            
            // 刷新阅读进度
            readMenu.bottomView.progressView.reloadProgress()
        }
    }
    
    /// 点击下一章
    func readMenuClickNextChapter(readMenu: DZMReadMenu!) {
        let last = readModel.recordModel?.isLastChapter
        if last.ok{
            
            DZMLog("已经是最后一章了")
            
        }else{
            
            goToChapter(chapterID: readModel.recordModel?.chapterModel.nextChapterID)
    
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
            
            // 刷新阅读进度
            readMenu.bottomView.progressView.reloadProgress()
        }
    }
    
    /// 拖拽阅读记录
    func readMenuDraggingProgress(readMenu: DZMReadMenu!, toPage: Int) {
        
        if readModel.recordModel?.page != toPage{
            
            readModel.recordModel?.page = NSNumber(value: toPage)
            
            creatPageController(displayController: getCurrentReadViewController())
            
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
        }
    }
    
    /// 拖拽章节进度(总文章进度,网络文章也可以使用)
    func readMenuDraggingProgress(readMenu: DZMReadMenu!, toChapterID: NSNumber, toPage: Int) {
        
        // 不是当前阅读记录章节
        if toChapterID != readModel!.recordModel?.chapterModel.id {
            
            goToChapter(chapterID: toChapterID, toPage: toPage)
            
            // 检查当前内容是否包含书签
            readMenu.topView.checkForMark()
        }
    }
    
    /// 切换进度显示(分页 || 总进度)
    func readMenuClickDisplayProgress(readMenu: DZMReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController())
    }
    
    /// 点击切换背景颜色
    func readMenuClickBGColor(readMenu: DZMReadMenu) {
        
        view.backgroundColor = DZMReadConfigure.shared.bgColor
        
        creatPageController(displayController: getCurrentReadViewController())
    }
    
    /// 点击切换字体
    func readMenuClickFont(readMenu: DZMReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
    }
    
    /// 点击切换字体大小
    func readMenuClickFontSize(readMenu: DZMReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
    }
    
    /// 点击切换间距
    func readMenuClickSpacing(readMenu: DZMReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController(isUpdateFont: true))
    }
    
    /// 点击切换翻页效果
    func readMenuClickEffect(readMenu: DZMReadMenu) {
        
        creatPageController(displayController: getCurrentReadViewController())
    }
    
    
    // MARK: 展示动画
    
    /// 辅视图展示
    func showLeftView(isShow:Bool, completion:DZMAnimationCompletion? = nil) {
     
        if isShow { // leftView 将要显示
            
            // 刷新UI 
            leftView.updateUI()
            
            // 滚动到阅读记录
            leftView.catalogView.scrollRecord()
            
            // 允许显示
            leftView.isHidden = false
        }
        
        UIView.animate(withDuration: READ_AD_TIME, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
            if isShow {
                
                self?.leftView.frame.origin = CGPoint.zero
                
                self?.contentView.frame.origin = CGPoint(x: READ_LEFT_VIEW_WIDTH, y: 0)
                
            }else{
                
                self?.leftView.frame.origin = CGPoint(x: -READ_LEFT_VIEW_WIDTH, y: 0)
                
                self?.contentView.frame.origin = CGPoint.zero
            }
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.leftView.isHidden = true }
            
            completion?()
        }
    }
    
    
}
