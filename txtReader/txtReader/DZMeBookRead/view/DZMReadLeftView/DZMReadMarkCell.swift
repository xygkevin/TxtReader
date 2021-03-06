//
//  ReadMarkCell.swift

//
//  
//

import UIKit

/// mark cell 高度
let READ_MARK_CELL_HEIGHT:CGFloat = SPACE_SA_100

class ReadMarkCell: UITableViewCell {

    private var title:UILabel!
    
    private var time:UILabel!
    
    private var content:UILabel!
    
    private(set) var spaceLine:UIView!
    
    var markModel:ReadMarkModel! {
        
        didSet{
            
            title.text = markModel.name
            
            time.text = TimerString(markModel.time.intValue)
            
            content.attributedText = TextLineSpacing(markModel.content, SPACE_5)
        }
    }
    
    class func cell(_ tableView:UITableView) ->ReadMarkCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ReadMarkCell")
        
        if cell == nil {
            
            cell = ReadMarkCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ReadMarkCell")
        }
        
        return cell as! ReadMarkCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        title = UILabel()
        title.font = FONT_SA_14
        title.textColor = COLOR_145_145_145
        contentView.addSubview(title)
        
        time = UILabel()
        time.font = FONT_SA_12
        time.textColor = COLOR_145_145_145
        time.textAlignment = .right
        contentView.addSubview(time)
        
        content = UILabel()
        content.font = FONT_SA_14
        content.textColor = COLOR_145_145_145
        content.numberOfLines = 0
        contentView.addSubview(content)
   
        spaceLine = SpaceLine(contentView, COLOR_230_230_230)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        let itemX = SPACE_SA_15
        let itemY = SPACE_SA_15
        let itemH = SPACE_SA_20
        let contentW = w - 2*itemX
        let contentY = itemY + itemH + SPACE_SA_10
        let itemW = (contentW - SPACE_SA_10) / 2
        
        
        title.frame = CGRect(x: itemX, y: itemY, width: itemW * 4/3, height: itemH)
        let timeW = itemW * 2/3
        time.frame = CGRect(x: w - timeW - itemX, y: itemY, width: timeW, height: itemH)
        
        content.frame = CGRect(x: itemX, y: contentY, width: contentW, height: READ_MARK_CELL_HEIGHT - contentY - SPACE_SA_15)
        
        spaceLine.frame = CGRect(x: SPACE_SA_15, y: h - SPACE_LINE, width: w - SPACE_SA_30, height: SPACE_LINE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
