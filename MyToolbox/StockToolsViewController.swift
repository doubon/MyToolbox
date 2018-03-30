//
//  StockToolsViewController.swift
//  MyToolbox
//
//  Created by doubon on 16/3/31.
//  Copyright © 2016年 doubon. All rights reserved.
//

import UIKit

class StockToolsViewController: UIViewController {
    @IBOutlet weak var tfStartValue: UITextField!
    @IBOutlet weak var tfEndValue: UITextField!
    @IBOutlet weak var tfPercent: UITextField!
    @IBOutlet weak var tfBuyingPrice: UITextField!
    @IBOutlet weak var tfSellingPrice: UITextField!
    @IBOutlet weak var tfTradeNumber: UITextField!
    @IBOutlet weak var lblT0Profit: UILabel!
    @IBOutlet weak var stackViewWorkArea: UIStackView!
    @IBOutlet weak var stackViewFluctuateRange: UIStackView!
    @IBOutlet weak var stackViewT0Profit: UIStackView!
    @IBOutlet weak var layoutConstraintWorkAreaLeading: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintWorkAreaTrailing: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintWorkAreaTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintWorkAreaBottom: NSLayoutConstraint!
    @IBOutlet weak var viewFluctuateRange: UIView!
    @IBOutlet weak var viewT0Profit: UIView!
    
    func updateLayoutConstraintWithRatioX(_ layoutConstraint: NSLayoutConstraint, initialConstant: CGFloat) -> Void {
        let ratioX: CGFloat = UIScreen.main.bounds.size.width / 375
        layoutConstraint.constant = initialConstant * ratioX
    }
    
    func updateLayoutConstraintWithRatioY(_ layoutConstraint: NSLayoutConstraint, initialConstant: CGFloat) -> Void {
        let ratioY: CGFloat = UIScreen.main.bounds.size.height / 667
        layoutConstraint.constant = initialConstant * ratioY
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewFluctuateRange.layer.cornerRadius = 5
        viewT0Profit.layer.cornerRadius = 5
        lblT0Profit.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateStackViewSpacing(stackView: UIStackView) -> Void {
        let screenHeight: Int = Int(UIScreen.main.bounds.size.height)
        var theSpacing: CGFloat
        switch screenHeight {
        case ..<667:
            theSpacing = 6
        case 667:
            theSpacing = 8
        case ..<1024:
            theSpacing = 20
        default:
            theSpacing = 40
        }
        stackView.spacing = theSpacing
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let ratioY: CGFloat = UIScreen.main.bounds.size.height / 667
        stackViewWorkArea.spacing = 20 * ratioY
        updateStackViewSpacing(stackView: stackViewFluctuateRange)
        updateStackViewSpacing(stackView: stackViewT0Profit)

        updateLayoutConstraintWithRatioY(layoutConstraintWorkAreaTop,      initialConstant: 20)
        updateLayoutConstraintWithRatioY(layoutConstraintWorkAreaBottom,   initialConstant: 20)
        updateLayoutConstraintWithRatioX(layoutConstraintWorkAreaLeading,  initialConstant: 20)
        updateLayoutConstraintWithRatioX(layoutConstraintWorkAreaTrailing, initialConstant: 20)
    }
    
    func showAlertMessage(_ message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resetFluctuateRang(_ sender: AnyObject) {
        tfStartValue.text = ""
        tfEndValue.text = ""
        tfPercent.text = ""
        tfStartValue.becomeFirstResponder()
    }
    
    //计算波动幅度
    @IBAction func calcFluctuateRange(_ sender: AnyObject) {
        let strStartValue = tfStartValue.text!
        let strEndValue = tfEndValue.text!
        let strPercent = tfPercent.text!
        let numberFormatter = NumberFormatter()
        
        if (strStartValue.count > 0) && (strEndValue.count > 0) {
            let dStartValue: Double = NSString(string: strStartValue).doubleValue
            let dEndValue: Double   = NSString(string: strEndValue).doubleValue
            
            let dPercent: Double = (dEndValue - dStartValue) / dStartValue
            
            numberFormatter.positiveFormat = "###,##0.##%"
            tfPercent.text = numberFormatter.string(from: NSNumber(value: dPercent as Double))
 
            refreshPercentFont(self)
        }
        else if strPercent.count > 0 {
            let dPercent: Double = NSString(string: strPercent).doubleValue
            if dPercent == 0 {
                showAlertMessage("波动幅度不能等于零！")
                return
            }
            
            if strStartValue.count > 0 {
                let dStartValue: Double = NSString(string: strStartValue).doubleValue
                let dEndValue: Double   = dStartValue * (1 + dPercent / 100)
                numberFormatter.positiveFormat = "###,##0.##"
                tfEndValue.text = numberFormatter.string(from: NSNumber(value: dEndValue as Double))
            }
            else if strEndValue.count > 0 {
                let dEndValue: Double   = NSString(string: strEndValue).doubleValue
                let dStartValue: Double = dEndValue / (1 + dPercent / 100)
                numberFormatter.positiveFormat = "###,##0.##"
                tfStartValue.text = numberFormatter.string(from: NSNumber(value: dStartValue as Double))
            }
            else {
                showAlertMessage("输入不完整！")
            }
        }
        else {
            showAlertMessage("输入不完整！")
        }
    }
    
    @IBAction func refreshPercentFont(_ sender: AnyObject) {
        let strPercent: String = tfPercent.text!
        let dPercent: Double = NSString(string: strPercent).doubleValue
        
        if dPercent > 0 {
            tfPercent.textColor = UIColor.red
        }
        else if dPercent < 0 {
            tfPercent.textColor = UIColor.green
        }
        else {
            tfPercent.textColor = UIColor.black
        }
    }
    
    @IBAction func tfPercent_EditingDidEnd(_ sender: AnyObject) {
        let strPercent: String = tfPercent.text!
        if (strPercent.count > 0) && !strPercent.hasSuffix("%") {
            tfPercent.text = strPercent + "%"
        }
    }
    
    @IBAction func resetT0ProfitInfo(_ sender: AnyObject) {
        tfBuyingPrice.text = ""
        tfSellingPrice.text = ""
        tfTradeNumber.text = ""
        lblT0Profit.text = ""
        tfBuyingPrice.becomeFirstResponder()
    }
    
    //计算股票“T+0”盈利
    @IBAction func calcT0Profit(_ sender: AnyObject) {
        let strBuyingPrice: String = tfBuyingPrice.text!
        let strSellingPrice: String = tfSellingPrice.text!
        let strTradeNumber: String = tfTradeNumber.text!
        
        let dBuyingPrice: Double = NSString(string: strBuyingPrice).doubleValue
        let dSellingPrice: Double = NSString(string: strSellingPrice).doubleValue
        let dTradeNumber: Double = NSString(string: strTradeNumber).doubleValue
        
        if dBuyingPrice == 0 {
            showAlertMessage("买入价格填写不正确！")
            tfBuyingPrice.becomeFirstResponder()
            return
        }
        
        if dSellingPrice == 0 {
            showAlertMessage("卖出价格填写不正确！")
            tfSellingPrice.becomeFirstResponder()
            return
        }
        
        if dSellingPrice <= dBuyingPrice {
            showAlertMessage("卖出价格必须大于买入价格！")
            tfSellingPrice.becomeFirstResponder()
            return
        }
        
        if dTradeNumber == 0 {
            showAlertMessage("成交数量填写不正确！")
            tfTradeNumber.becomeFirstResponder()
            return
        }
        
        if dTradeNumber < 100 {
            showAlertMessage("成交数量不能少于100股！")
            tfTradeNumber.becomeFirstResponder()
            return
        }
        
        //买入金额
        let dBuyingMoney = dBuyingPrice * dTradeNumber
        
        //买入佣金
        var dFeeIn: Double = dBuyingMoney * 3 / 10000
        if dFeeIn < 5 {
            dFeeIn = 5
        }
        
        //买入总支出
        let dBuyingTotal = dBuyingMoney + dFeeIn
        
        
        //卖出金额
        let dSellingMoney = dSellingPrice * dTradeNumber
        
        //卖出佣金
        var dFeeOut: Double = dSellingMoney * 3 / 10000
        if dFeeOut < 5 {
            dFeeOut = 5
        }
        
        //卖出印花税
        let dStampTax = dSellingMoney * 0.001
        
        //沪市每1000股收取1元过户费
        /*
        var dFeeOther: Double = dTradeNumber / 1000
        if (dFeeOther == 0) || (dTradeNumber % 1000 != 0) {
          dFeeOther += 1
        }
        */
        
        //卖出总收入
        let dSellingTotal = dSellingMoney - dFeeOut - dStampTax
        
        //净收益
        let dNetProfit = dSellingTotal - dBuyingTotal
        
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "###,##0.##"
        lblT0Profit.text = String(format: "%@ 元",
            numberFormatter.string(from: NSNumber(value: dNetProfit as Double))!)
    }
}

