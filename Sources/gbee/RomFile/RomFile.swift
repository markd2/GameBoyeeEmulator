import Foundation

class RomFile {
    /// Where the ROM file lives in the file system
    let url: URL

    /// The whole contents of the ROM file.
    let data: Data

    init(fileLocation: URL) throws {
        self.url = fileLocation

        self.data = try Data(contentsOf: url)
        print(data.count)
    }

    func splunge() {
        entryPoint()
    }

    func entryPoint() {
        data.withUnsafeBytes { rawBufferPointer in
            let basePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            for i in 0 ..< 4 {
                let byte = basePointer[0x100 + i]
                let blah = switch byte {
                case 0x00:
                    "00: nop"
                case 0xC3:
                    "C3: jp"
                default:
                    String(format: "%02x", byte)
                }
                print(blah)
            }
        }
    }
}
