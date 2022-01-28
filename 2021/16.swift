import Foundation

enum Op {
    case sum, product, min, max, gr, le, eq
}

enum Packet {
    case valuePacket(version: Int, value: Int)
    indirect case operatorPacket(version: Int, op: Op, packets: [Packet])
    
    init?(from reader: BitReader) {
        let version = reader.read(count: 3)
        let typeId = reader.read(count: 3)

        let op: Op

        switch typeId {
            case 4:
                var done = false
                var value = 0
                while !done {
                    done = reader.read(count: 1) == 0
                    value = value << 4 + reader.read(count: 4)
                }
                self = .valuePacket(version: version, value: value)
                return
            case 0:
                op = .sum
            case 1:
                op = .product
            case 2:
                op = .min
            case 3:
                op = .max
            case 5:
                op = .gr
            case 6:
                op = .le
            case 7:
                op = .eq
            default:
                return nil
        }
        
            var packets: [Packet] = []
            if reader.read(count: 1) == 0 {
                let total = reader.read(count: 15) + reader.position
                while reader.position != total {
                    guard let packet = Packet(from: reader) else {
                        return nil
                    }
                    packets.append(packet)
                }
            } else {
                let num = reader.read(count: 11)
                for _ in 0..<num {
                    guard let packet = Packet(from: reader) else {
                        return nil
                    }
                    packets.append(packet)
                }
            }
            
            self = .operatorPacket(version: version, op: op, packets: packets)
    }
    
    func versionSum() -> Int {
        switch self {
        case .valuePacket(version: let v, value: _):
            return v
        case .operatorPacket(version: let v, op: _, packets: let packets):
            return packets.reduce(v) { $0 + $1.versionSum() }
        }
    }

    func eval() -> Int {
        switch self {
        case .valuePacket(version: _, value: let val):
            return val
        case .operatorPacket(version: _, op: let op, packets: let packets):
            let ops = packets.map { $0.eval() }
            switch op {
                case .sum:
                    return ops.reduce(0) { $0 + $1 }
                case .product:
                    return ops.reduce(1) { $0 * $1 }
                case .min:
                    return ops.reduce(ops[0], min)
                case .max:
                    return ops.reduce(ops[0], max)
                case .gr:
                    return ops[0] > ops[1] ? 1 : 0
                case .le:
                    return ops[0] < ops[1] ? 1 : 0
                case .eq:
                    return ops[0] == ops[1] ? 1 : 0
            }
        }
 
    }
}


class BitReader {
    private var bits: [Bool]
    private var index = 0
    
    var position: Int {
        index
    }
    
    init(input: String) {
        bits = []
        
        for c in input {
            let n = Int(String(c), radix: 16)!
            
            for i in 0...3 {
                let bit = n & (1 << (3 - i)) != 0
                bits.append(bit)
            }
        }
    }
    
    func read(count: Int) -> Int {
        var n = 0
        for _ in 0..<count {
            n = n << 1
            if (bits[index]) {
                n += 1
            }
            index += 1
        }
        return n
    }
}

func part1(_ input: String) -> Int {
    let reader = BitReader(input: input)
    let packet = Packet(from: reader)!
    return packet.versionSum()
}

func part2(_ input: String) -> Int {
    let reader = BitReader(input: input)
    let packet = Packet(from: reader)!
    return packet.eval()
}

let part1Tests = [
    ("D2FE28", 6),
    ("8A004A801A8002F478", 16),
    ("620080001611562C8802118E34", 12),
    ("C0015000016115A2E0802F182340", 23),
    ("A0016C880162017C3686B18A3D4780", 31),
]

for (input, expected) in part1Tests {
    let result = part1(input)
    if expected != result {
        print("part1: \(input); expected: \(expected); got: \(result) ")
        exit(1)
    }
}

let part2Tests = [
    ("C200B40A82", 3),
    ("04005AC33890", 54),
    ("880086C3E88112", 7),
    ("CE00C43D881120", 9),
    ("D8005AC2A8F0", 1),
    ("F600BC2D8F", 0),
    ("9C005AC2F8F0", 0),
    ("9C0141080250320F1802104A08", 1),
]

for (input, expected) in part2Tests {
    let result = part2(input)
    if expected != result {
        print("part1: \(input); expected: \(expected); got: \(result) ")
        exit(1)
    }
}

let file = URL(fileURLWithPath: "16.txt")
let input = try String(contentsOf: file)
print(part1(input))
print(part2(input))
