//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground 😬"

// MARK: Function
// a function to reverse a string
func reverseAString(str : String) -> String {
    // initialize a character array to hold the characters of the string that we want to be reversed
    var strCharacters = [Character](str.characters)
    
    // create an empty string that's going to be initial string but reversed. We need to do it in order to return this string
    var reversedStr = String()
    
    // in order to make our initial string reversed we need to run a loop from the very last element of the array to the first one and append each one to the string that was initialized above
    
    var index = strCharacters.count-1
    while index > 0 {
        reversedStr.append(strCharacters[index])
        index -= 1
    }
    
    //    NOTE: I could've written a simpler cycle, but it's using the "reverse" method
    //    for i in (0..<strCharacters.count).reverse() {
    //        reversedStr.append(strCharacters[i])
    //    }

    return reversedStr
}

// MARK: Extension
// I've decided to write an extension as well. It uses exactly the same technique as the above funciton. Just a little bit more convenient in my opinion.
extension String {
    func reversed() -> String {
        var strCharacters = [Character](self.characters)
        
        var reversedStr = String()
        
        var index = strCharacters.count-1
        while index > 0 {
            reversedStr.append(strCharacters[index])
            index -= 1
        }
        
        return reversedStr
    }
}


// MARK: Usage
// function 
reverseAString(str)
// extension
str.reversed()
