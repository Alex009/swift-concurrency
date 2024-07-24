import UIKit
import MD5Hash

var result = [String]()

let start = CFAbsoluteTimeGetCurrent()

func addNewItem() {
    let hash = generateMD5Hash(strings: result)
    
    var newResult = result
    newResult.append(hash)
    result = newResult
}

for _ in 1...1000 {
    addNewItem()
}

print("Result: \(result.last ?? "")")
let diff = CFAbsoluteTimeGetCurrent() - start
print("Time spent: \(diff) seconds")

RunLoop().run()

// review:
// верно
