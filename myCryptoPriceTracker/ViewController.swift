import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var crpCcy: [String] = []
    
    var ccy: [String] = []
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return crpCcy.count
        } else {
            return ccy.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return crpCcy[row]
        } else {
            return ccy[row]
        }
    }
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        getPrice(crpCcy: crpCcy[picker.selectedRow(inComponent: 0)], ccy: ccy[picker.selectedRow(inComponent: 1)], onResult: showResult)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        crpCcy = ["BTC", "DOGE", "ETH", "PEPE", "SNEK" ,"SHIB"]
        ccy = ["RUB", "EUR", "HKD", "JPY", "TRY", "USD"]
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        getPrice(crpCcy: crpCcy[picker.selectedRow(inComponent: 0)], ccy: ccy[picker.selectedRow(inComponent: 1)], onResult: showResult)
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getPrice(crpCcy: crpCcy[picker.selectedRow(inComponent: 0)], ccy: ccy[picker.selectedRow(inComponent: 1)], onResult: showResult)
    }
    
    
    func showResult(result: String) {
        DispatchQueue.main.async { [self] in
            price.text = result
        }
    }
    
    func getPrice(crpCcy: String, ccy: String, onResult: @escaping (String) -> Void) {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=\(crpCcy)&tsyms=\(ccy)") {
            URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let data = data {
                    if let json = try?JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        if let price = json[ccy] {
                            let formatter = NumberFormatter()
                            formatter.currencyCode = ccy
                            formatter.numberStyle = .currency
                            let formattedPrice = formatter.string(from: NSNumber(value: price))
                            onResult(formattedPrice ?? "")
                        }
                    } else {
                        onResult("An error occurred. Incorrect currrency")
                    }
                } else {
                    onResult("An error occurred. Press Refresh")
                }
            }.resume()
        }
    }
}

