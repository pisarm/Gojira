//: Playground - noun: a place where people can play


//private var refresh = 2400
//
//private let intervalData = [
//    ("10 mins",  600),
//    ("20 mins", 1200),
//    ("30 mins", 1800),
//    ("40 mins", 2400),
//    ("50 mins", 3000),
//    ("60 mins", 3600)
//]
//
//for (key, value) in intervalData {
//    if value == refresh {
//        print(key)
//        break
//    }
//}


//protocol GDL90_Enum  {
//    var description: String { get }
//}

enum Intervals: Int {
    case Ten = 600
    case Twenty = 1200
    case Thirty = 1800
    case Fourty = 2400
    case Fifty = 3000
    case Sixty = 3600

    var description: String {
        switch self {
        case .Ten:
            return "10 mins"
        case .Twenty:
            return "20 mins"
        case .Thirty:
            return "30 mins"
        case .Fourty:
            return "40 mins"
        case .Fifty:
            return "50 mins"
        case .Sixty:
            return "60 mins"
        }
    }
}