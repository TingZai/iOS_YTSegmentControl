//
//  YTSegmentControl.swift
//  03-自定义分段选择器
//
//  Created by 余婷 on 16/8/26.
//  Copyright © 2016年 余婷. All rights reserved.
//

import UIKit

let BtnTag = 100

class YTSegmentControl: UIView {
    
    //MARK: - 属性
    ///1.当前被选中的按钮的下标
    var selectedSegmentIndex = 0{
    
        //将要将新值赋给selectedSegmentIndex。这个selectedSegmentIndex还是原来
        willSet{
            //1.先将原来选中的按钮变成非选中状态
            let btn1 = self.viewWithTag(BtnTag
             + selectedSegmentIndex) as! UIButton
            btn1.selected = false
            btn1.titleLabel?.font = self.normalFont
            //2.将指定的按钮变成选中状态
            //newValue -> 将要赋给当前属性的那个新的值
            let btn2 = self.viewWithTag(BtnTag + newValue) as! UIButton
            btn2.selected = true
            btn2.titleLabel?.font = self.selectedFont
            
        }
        
        //已经给selectedSegmentIndex赋值
        didSet{
        
            UIView.animateWithDuration(0.2) {
                
                self.slider.frame.origin.x = CGFloat(self.selectedSegmentIndex) * self.slider.frame.size.width
            }
        }
        
    }
    
    
    ///2.文字选中的颜色
    var titleSelectedColor = UIColor.blueColor(){
    
        didSet{
            
            //更新滑块的背景颜色
            self.slider.backgroundColor = self.sliderColor
            
            for item in self.subviews {
                
                if item.tag >= BtnTag {
                    let btn = item as! UIButton
                    //改变按钮的文字颜色
                    btn.setTitleColor(self.titleSelectedColor, forState: .Selected)
                }
            }
            
        }
    }
    
    ///3.文字颜色
    var titleColor = UIColor.blackColor(){
    
        //每次从外部给titleColor属性赋值的时候，都需要用最新的titleColor的值去更新按钮的文字颜色
        didSet{
        
            for item in self.subviews {
                
                if item.tag >= BtnTag {
                    let btn = item as! UIButton
                    //改变按钮的文字颜色
                    btn.setTitleColor(self.titleColor, forState: .Normal)
                }
            }
            
        }
    }
    ///4.items
    private var items:[String]
    ///5.滑块
    private var slider = UIView()
    
    ///6.保存target
    private var target: AnyObject? = nil
    ///7.保存action
    private var action: Selector? = nil
    ///8.选中的字体
    var selectedFont = UIFont.boldSystemFontOfSize(14)
    ///9.非选中的字体
    var normalFont = UIFont.systemFontOfSize(13)
    ///10.滑块的颜色
    var sliderColor = UIColor.whiteColor()
    ///11.滑块的高度
    var sliderHeight:CGFloat = 2
    
    
    
    
    
    //MARK: - 构造方法
    init(items:[String]){
       self.items = items
        //CGRectZero ->坐标是(0,0),大小是(0,0)
       super.init(frame: CGRectZero)
       
        //创建items中的每个数组元素对应的按钮
        self.creatSubView()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//MARK: - 提供给外部使用的方法
extension YTSegmentControl{

    //保存target和action值
    func addTarget(target:AnyObject?, action:Selector) {
        
        self.target = target
        self.action = action
    }
}

//MARK: - 创建子视图
extension YTSegmentControl{

    func creatSubView() {
        
        //1.创建按钮
        for (i,item) in self.items.enumerate() {
            //创建按钮不设置frame属性
            let btn = UIButton.init()
            //设置文字
            btn.setTitle(item, forState: .Normal)
            //设置tag值
            btn.tag = BtnTag + i
            
            //设置文字颜色
            btn.setTitleColor(self.titleColor, forState: .Normal)
            btn.setTitleColor(self.titleSelectedColor, forState: .Selected)
            //让默认第0个按钮处于选中状态
            if i == 0 {
                
                btn.selected = true
            }
            
            //添加点击事件
            btn.addTarget(self, action: "btnAction:", forControlEvents: .TouchDown)
            
            
            //添加到界面上
            self.addSubview(btn)
        }
        
        //2.创建滑块
        self.slider.backgroundColor = self.titleSelectedColor
        self.addSubview(self.slider)
        
    }
}

//MARK: - 按钮点击事件
extension YTSegmentControl{

    func btnAction(btn:UIButton) {
        
        if self.selectedSegmentIndex != btn.tag - BtnTag {
            //更新选中的下标
            self.selectedSegmentIndex = btn.tag - BtnTag
            
            //通知外部值改变了
            if self.target != nil {
                
                //让target去调用action中的方法
                //参数1:需要调用的方法对应的Selecter
                //参数2:如果Selecter中方法带参，那个这个参数的值就是Selecter中方法的实参
                self.target?.performSelector(self.action!, withObject:self)
            }
            
        }
        
        
        
    }
}

//MARK: - 计算子视图的frame
extension YTSegmentControl{

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //当前分段选择器的宽和高
        let segementW = self.frame.size.width
        let segementH = self.frame.size.height
        
        //1.计算按钮的frame
        let btnW = segementW/CGFloat(self.items.count)
        let btnH = segementH
        let btnY: CGFloat = 0
        
        //遍历所有的子视图
        var i: CGFloat = 0
        for item in self.subviews {
            //找到其中的按钮
            if item.tag >= BtnTag {
                
                let btn = item as!UIButton
                
                let btnX = i * btnW
                item.frame = CGRectMake(btnX, btnY, btnW, btnH)
                
                //设置按钮的字体
                if btn.selected {
                    
                    btn.titleLabel?.font = self.selectedFont
                }else{
                
                    btn.titleLabel?.font = self.normalFont
                }
                
                
                //找到一个按钮i加1
                i += 1
            }
            
        }
        
        //2.计算滑块的frame
        let sliderX = CGFloat(self.selectedSegmentIndex) * btnW
        let sliderH: CGFloat = self.sliderHeight
        let sliderY = segementH - sliderH
        let sliderW = btnW
        self.slider.frame = CGRectMake(sliderX, sliderY, sliderW, sliderH)
        
        //3.设置滑块颜色
        self.slider.backgroundColor = self.sliderColor

    }
}
