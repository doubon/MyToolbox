//
//  IncomeTaxController.swift
//  MyToolbox
//
//  Created by doubon on 16/3/31.
//  Copyright © 2016年 doubon. All rights reserved.
//

import UIKit

class IncomeTaxViewController: UIViewController {
    @IBOutlet weak var tfBeforeMoney: UITextField!
    @IBOutlet weak var tfSocialMoney: UITextField!
    @IBOutlet weak var tfBaseMoney: UITextField!
    @IBOutlet weak var lblPayTax: UILabel!
    @IBOutlet weak var lblRealWage: UILabel!
    @IBOutlet weak var tfAfterMoney: UITextField!
    @IBOutlet weak var lblBeforeMoney: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lblPayTax.text = nil
        lblRealWage.text = ""
        lblBeforeMoney.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let userDefaults = UserDefaults.standard
        var baseMoney: Double = userDefaults.double(forKey: "BaseMoney")
        if baseMoney <= 0 {
            baseMoney = 3500.0
        }
        tfBaseMoney.text = String(format: "%.0f", baseMoney)
    }
    
    func showAlertMessage(_ message: String) {
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getPayTax(_ beforeMoney: Double, socialMoney: Double, baseMoney: Double) -> Double {
        //应纳税所得额 = 税前工资 - 各项社会保险费 - 起征点
        let taxMoney = beforeMoney - socialMoney - baseMoney
        
        //应缴税额 = 应纳税所得额 * 税率 - 速算扣除数
        if taxMoney > 0 {
            var taxRate: Double = 0
            var quickValue: Double = 0

            if (taxMoney > 0) && (taxMoney <= 1500) {
                taxRate    = 0.03
                quickValue = 0
            } else if (taxMoney > 1500) && (taxMoney <= 4500) {
                taxRate    = 0.10
                quickValue = 105
            } else if (taxMoney > 4500) && (taxMoney <= 9000) {
                taxRate    = 0.20
                quickValue = 555
            } else if (taxMoney > 9000) && (taxMoney <= 35000) {
                taxRate    = 0.25
                quickValue = 1005
            } else if (taxMoney > 35000) && (taxMoney <= 55000) {
                taxRate    = 0.30
                quickValue = 2775
            } else if (taxMoney > 55000) && (taxMoney <= 80000) {
                taxRate    = 0.35
                quickValue = 5505
            } else if taxMoney > 80000 {
                taxRate    = 0.45
                quickValue = 13505
            }
            return taxMoney * taxRate - quickValue
        } else {
            return 0
        }
    }

    //计算税后工资
    @IBAction func CalcAfterTax(_ sender: AnyObject) {
        tfBeforeMoney.resignFirstResponder()
        tfSocialMoney.resignFirstResponder()
        tfBaseMoney.resignFirstResponder()
        
        let dBeforeMoney: Double = NSString(string: tfBeforeMoney.text!).doubleValue
        if !(dBeforeMoney > 0) {
            showAlertMessage("税前工资必须大于零！")
            //tfBeforeMoney.becomeFirstResponder()
            return
        }
        
        let dSocialMoney: Double = NSString(string: tfSocialMoney.text!).doubleValue
        if dSocialMoney < 0 {
            showAlertMessage("各项社会保险费必须大于等于零！")
            //tfSocialMoney.becomeFirstResponder()
            return
            
        }
        
        let dBaseMoney: Double = NSString(string: tfBaseMoney.text!).doubleValue
        if !(dBaseMoney > 0) {
            showAlertMessage("起征点必须大于零！")
            //tfBaseMoney.becomeFirstResponder()
            return
        }
        
        let payTax = getPayTax(dBeforeMoney, socialMoney: dSocialMoney, baseMoney: dBaseMoney)
        lblPayTax.text = String(format: "%.2f 元", payTax)

        //实发工资 = 税前工资 - 各项社会保险费 - 应缴税额
        let realWage = dBeforeMoney - dSocialMoney - payTax
        lblRealWage.text = String(format: "%.2f 元", realWage)
    }

    @IBAction func calcAfterTax_EditingChanged(_ sender: AnyObject) {
        lblPayTax.text = ""
        lblRealWage.text = ""
    }
    
    //反推税前工资
    @IBAction func CalcBeforeTax(_ sender: AnyObject) {
        tfBeforeMoney.resignFirstResponder()
        tfSocialMoney.resignFirstResponder()
        tfBaseMoney.resignFirstResponder()
        
        let dAfterMoney: Double = NSString(string: tfAfterMoney.text!).doubleValue
        if !(dAfterMoney > 0) {
            showAlertMessage("税后工资必须大于零！")
            //tfAfterMoney.becomeFirstResponder()
            return
        }
        
        let dBaseMoney: Double = NSString(string: tfBaseMoney.text!).doubleValue
        if !(dBaseMoney > 0) {
            showAlertMessage("起征点必须大于零！")
            //tfBaseMoney.becomeFirstResponder()
            return
        }
        
        var beforeMoney, payTax, theMoney: Double
        if dAfterMoney <= dBaseMoney {
            beforeMoney = dAfterMoney
        } else {
            theMoney = round(dAfterMoney).truncatingRemainder(dividingBy: 50)
            beforeMoney = dAfterMoney - theMoney + 50;
            payTax = getPayTax(beforeMoney, socialMoney: 0, baseMoney: dBaseMoney)
            while beforeMoney - payTax < dAfterMoney {
                beforeMoney += 50
                payTax = getPayTax(beforeMoney, socialMoney: 0, baseMoney: dBaseMoney)
            }
        }
        lblBeforeMoney.text = String(format: "%.2f 元", beforeMoney)
    }
    
    @IBAction func calcBeforeTax_EditingChanged(_ sender: AnyObject) {
        lblBeforeMoney.text = ""
    }
}

