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
        nintendoLogo()
    }

    func nintendoLogo() {
        print(0x11b - 0x104)
        print(0x133 - 0x104)
        data.withUnsafeBytes { rawBufferPointer in
            let basePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            // top half
            var pixels: [String] = []
            for i in 0x104 ... 0x11B {
                let byte = basePointer[i]
                // for each half, each nibble encodes 4 pixels
                //    the MSB to the left-most pixel
                //    the LSB to the right-most pixel
                // pixel is lit i the corresponding bit is set
                // the 4-pixel groups are laid out top to bottom,
                // left to right
                // 12 by 4 nybbles

                // top nibble
                var top = byte >> 4
                var topFourPixGroup = ""
                for _ in 0 ..< 4 {
                    topFourPixGroup += (top & 0x01 == 0) ? " " : "*"
                    top = top >> 1
                }

                // bottom nibble
                var bottom = byte >> 4
                var bottomFourPixGroup = ""
                for _ in 0 ..< 4 {
                    bottomFourPixGroup += (bottom & 0x01 == 0) ? " " : "*"
                    bottom = bottom >> 1
                }

                pixels.append(topFourPixGroup)
                pixels.append(bottomFourPixGroup)
            }

            for y in 0 ..< 4 {
                for x in 0 ..< 12 {
                    print(pixels[y + x * 4], terminator: "")
                }
                print("")
            }
        }
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
