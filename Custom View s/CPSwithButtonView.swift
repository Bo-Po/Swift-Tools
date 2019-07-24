//
//  CPSwithButtonView.swift
//  swift-OC
//
//  Created by mac on 2019/5/21.
//  Copyright © 2019年 bo. All rights reserved.
//

import UIKit


let BUTTON_TAG = 10000;

class CPSwithButtonView: UIView {
    
    public enum CPSwithButtonType: Int {
        case fixed
        case scroll
    }
    private var _font = UIFont.systemFont(ofSize: 15);
    private var lineWidth: Float = 0;
    private var spacing: Float = 0;
    var buttons: [UIButton] = [];
    var selectedAtIndex: UInt {
        didSet {
            for btn in buttons {
                if UInt(btn.tag - BUTTON_TAG) == selectedAtIndex {
                    btn.setTitleColor(color_selected, for: .normal);
                    lineView.center = CGPoint(x: btn.center.x, y: lineView.center.y);
                    btn.isUserInteractionEnabled = false;
                } else {
                    btn.setTitleColor(color_default, for: .normal);
                    btn.isUserInteractionEnabled = true;
                }
            }
        }
    };
    var didTappedButton: CPClickButton?;
    var type: CPSwithButtonType = .fixed;
    lazy var lineView: UIView = {
        return UIView();
    }()
    lazy var cp_scroll: UIScrollView = {
        let scroll = UIScrollView();
        scroll.contentOffset = CGPoint(x: 0, y: 0);
        scroll.contentSize = CGSize(width: 0, height: 0);
        scroll.bounces = false;
        scroll.showsHorizontalScrollIndicator = false;
        return scroll;
    }()
    var color_default: UIColor = .white;
    var color_selected: UIColor = .white;
    
    override init(frame: CGRect) {
        selectedAtIndex = 0;
        super.init(frame: frame);
        backgroundColor = .clear;
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        selectedAtIndex = 0;
        super.init(coder: aDecoder);
        backgroundColor = .clear;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        if buttons.count > 0 {
            if type == .scroll {
                cp_scroll.frame = bounds;
            }
            // 计算按钮最大宽度
            var btnWidth = (Float(frame.size.width) - spacing * 2) / Float(buttons.count);
            var totalX = spacing;
            for btn in buttons {
                if (type == .scroll) {
                    let size = btn.frame.size;
                    btnWidth = Float(size.width);
                }
                btn.frame = CGRect(x: CGFloat(totalX), y: 10, width: CGFloat(btnWidth), height: 20);
                totalX += btnWidth;
            }
            let btn = buttons[Int(selectedAtIndex)];
            var fram = lineView.frame;
            fram.size.width = btn.bounds.size.width - CGFloat(lineWidth) * 2;
            lineView.frame = fram;
            lineView.center = CGPoint(x: btn.center.x, y: lineView.center.y);
        }
        
    }
    
    func setButtonTiltles(titles:[String]) {
        createSwithButton(titles: titles, font: _font, defaultColor: color_default, selectedColor: color_selected);
    }
    
    func createSwithButton(titles:[String], font: UIFont? ,defaultColor: UIColor?, selectedColor: UIColor?) -> Void {
        if let _ = defaultColor {
            color_default = defaultColor!;
        }
        if let _ = selectedColor {
            color_selected = selectedColor!;
        }
        if let _ = font {
            _font = font!;
        }
        
        if titles.count == 0 {
            return;
        }
        for btn in buttons {
            btn.removeFromSuperview();
        }
        buttons.removeAll();
        // 设定按钮左右边距
        if titles.count < 4 {
            spacing = 20.0;
            lineWidth = 20.0;
        } else {
            spacing = 10.0;
            lineWidth = 10.0;
        }
        // 计算按钮最大宽度
        var btnWidth = (Float(frame.size.width) - spacing * 2) / Float(titles.count);
        var totalX = spacing;
        var fristWidth: Float = 0;
        // 添加按钮
        for (idx, title) in titles.enumerated() {
            if type == .scroll {
                let size = title.size(withAttributes: [.font: _font]);
                btnWidth = Float(size.width) + spacing * 2;
            }
            // 初始化按钮
            let btn = UIButton(frame: CGRect(x: CGFloat(totalX), y: 10, width: CGFloat(btnWidth), height: 20));
            if idx == selectedAtIndex {
                btn.setTitleColor(color_selected, for: .normal);
                btn.isUserInteractionEnabled = false;
            } else {
                btn.setTitleColor(color_default, for: .normal);
                btn.isUserInteractionEnabled = true;
            }
            btn.setTitle(title, for: .normal);
            btn.backgroundColor = .clear;
            btn.tag = BUTTON_TAG + idx;
            btn.titleLabel?.font = font;
            btn.addTarget(self, action: #selector(tapButton(sender:)), for: .touchUpInside);
            // 把按钮添加到数组里，以便调用方设置
            buttons.append(btn);
            if type == .scroll {
                self.addSubview(cp_scroll);
                cp_scroll.addSubview(btn);
            } else {
                self.addSubview(btn);
            }
            totalX += btnWidth;
            if idx == selectedAtIndex {
                fristWidth = btnWidth;
            }
        }
        
        // 添加下侧滑动线
        lineView.frame = CGRect(x: CGFloat(spacing + lineWidth), y: frame.size.height-3, width: CGFloat(fristWidth - lineWidth * 2), height: 3.0);
        // 设置背景颜色为蓝色（2CA1F9）
        lineView.backgroundColor = color_selected;
        if type == .scroll {
            cp_scroll.contentSize = CGSize(width: CGFloat(totalX + spacing), height: 0);
            cp_scroll.addSubview(lineView);
        } else {
            self.addSubview(lineView);
        }
    }
    
    @objc func tapButton(sender: UIButton) {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseOut], animations: { [weak self] in
            var fram = self?.lineView.frame;
            fram?.size.width = sender.bounds.size.width - CGFloat((self?.lineWidth)!) * 2;
            self?.lineView.frame = fram!;
            self?.lineView.center = CGPoint(x: sender.center.x, y: (self?.lineView.center.y)!);
        }) { (finished) in
            
        }
        selectedAtIndex = UInt(sender.tag - BUTTON_TAG);
//        for btn in buttons {
//            if btn == sender {
//                sender.setTitleColor(color_selected, for: .normal);
//                sender.isUserInteractionEnabled = false;
//            }else{
//                sender.setTitleColor(color_default, for: .normal);
//                sender.isUserInteractionEnabled = true;
//            }
//        }
        didTappedButton?(self, Int64(selectedAtIndex));
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
