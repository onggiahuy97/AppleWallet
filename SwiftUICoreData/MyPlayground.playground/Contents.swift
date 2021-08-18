import UIKit

let number = "1234123412341234"

var res = ""
number.enumerated().forEach { ele in
    if (ele.offset + 1) % 4 == 0 {
        res.append("\(ele.element) ")
    } else {
        res.append(ele.element)
    }
}
print(res)
