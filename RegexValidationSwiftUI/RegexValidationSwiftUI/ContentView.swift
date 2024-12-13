//
//  ContentView.swift
//  RegexValidationSwiftUI
//
//  Created by Macbook on 10/12/24.
//

import SwiftUI

struct ContentView: View {
    // Validate singal value
    private let identifier = "aiPayment"
    
    // Assume parameters to validate, which reived in the form of JSON response
    private let params: [String: String] = [
        "orderType": "Buy",
        "orderProductCode": "ABDC.EF",
        "orderSubaccoutId": "ID1234567-890"
    ]
    
    
    //Assume this response coming from the another request to validate the above paramater list
    private let regexDict: [String: String] = [
        "journeyName": "^[a-zA-Z0-9]{1,64}$",
        "orderType": "^(Buy|Orders|Sell)$",
        "orderProductCode": "^(|[a-zA-Z0-9]{1,12}.[a-zA-Z]{0,4}((.)*([a-zA-Z]{1,2})*)*)$",
        "orderSubaccoutId": "^(ID[0-9]{7}-[0-9]{3}|)$"
    ]
    
    @State private var validationStatus = false
    @State private var valueToValidate = ""
    @State private var regexPattern = ""
    @State private var errorMessages = "Enter value and regex"
    @State private var isTextFieldValidated = false
    var body: some View {
        VStack {
            HStack {
                Text("Status: ")
                Text(validationStatus ? "SUCCESS" : "FAILED")
                    .foregroundStyle(validationStatus ? .green : .red)
            }
            TextField("Enter text to validate", text: $valueToValidate)
                .padding()
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
            TextField("Enter Regex", text: $regexPattern)
                .padding()
            
            Text(isTextFieldValidated ? "" : self.errorMessages)
                .foregroundStyle(isTextFieldValidated ? .clear : .red)
            
            Button {
            
                if valueToValidate.isEmpty || regexPattern.isEmpty || regexPattern.contains(where: { $0.isWhitespace }) {
                    isTextFieldValidated = false
                    return
                }
                isTextFieldValidated = true
                self.validateWithTextFieldValues()
            } label: {
                Text("Validate")
                    .font(.title2)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 20))
            
        }
        .padding()
    }
    
    func validate(value: String, pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSRange(location: 0, length: value.utf16.count)
            // return regex.firstMatch(in: value, options: [], range: range) != nil
            let matches = regex.matches(in: value, options: [], range: range)
            print(matches)
            return !matches.isEmpty
        } catch {
            print("Invalid regex: \(pattern)")
            validationStatus = false
            errorMessages = "Invalid Regex"
            return false
        }
    }
    
    func validateWithTextFieldValues() {
        let validation = validate(value: identifier, pattern: regexPattern)
        print("Identifier validation: \(validation ? "Success" : "Failed")")
        self.validationStatus = validation
    }
    
    // Function to validate a value against a regex pattern
    func validateClicked() {
        // Extract and validate the identifier using the "journey_name" regex
        if let journeyRegex = regexDict["journeyName"] {
            let journeyValidation = validate(value: identifier, pattern: journeyRegex)
            print("Identifier validation: \(journeyValidation ? "Success" : "Failed")")
            self.validationStatus = journeyValidation
        }
        
        // Param validation
        for (key, value) in params {
            if let pattern = regexDict[key] {
                let isValid = validate(value: value, pattern: pattern)
                print("\(key) validation: \(isValid ? "Success" : "Failed")")
                self.validationStatus = isValid
            } else {
                print("\(key) does not have a regex pattern in the dictionary.")
                self.validationStatus = false
            }
        }
    }
}

#Preview {
    ContentView()
}
