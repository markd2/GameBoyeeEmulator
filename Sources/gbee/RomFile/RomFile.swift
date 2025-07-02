import Foundation

class RomFile {
    /// Where the ROM file lives in the file system
    let url: URL

    /// The whole contents of the ROM file.
    let data: Data

    init(fileLocation: URL) throws {
        self.url = fileLocation

        self.data = try Data(contentsOf: url)
    }

    func splunge() {
        entryPoint()
        nintendoLogo()
        title()
        if oldLicenseeCode() == 0x33 {
            print("NEED TO DO NEW LICENSEE CODE")
        }
    }

    func oldLicenseeCode() -> UInt8 {
        data.withUnsafeBytes { rawBufferPointer in
            let basePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            let code = basePointer[0x14b]
            print(code)
            print(lookupOldLicenseeCode(code: Int(code)))
            return code
        }
    }

    func title() {
        data.withUnsafeBytes { rawBufferPointer in
            let basePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)
            var title = ""

            // "in later cartridges, the manufacture code lives in 
            // 0x13f .. 0x142 (in ascii).  Don't have a rom yet with that,
            // so for now just look at all the title bytes.
            // and 0x143 has a color game boy tag. $80 = supports CGB but
            // is monochrome compatable.
            // $C0 is works on CGB only)
            // setting bit 7 will trigger a write of this register vale
            // to KEY0 register which sets the CPU mode
            for i in 0x134 ... 0x143 {
                let asciiByte = rawBufferPointer[i]
                guard asciiByte != 0 else {
                    break
                }
                let unicodeScalar = UnicodeScalar(asciiByte)
                let character = Character(unicodeScalar)
                title.append(character)
            }
            print(title)
        }
    }

    func nintendoLogo() {
        data.withUnsafeBytes { rawBufferPointer in
            let basePointer = rawBufferPointer.baseAddress!.assumingMemoryBound(to: UInt8.self)

            // accumulate the 4-"pixels" as little strings
            var pixels: [String] = []
            for i in 0x104 ... 0x133 {
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
                var bottom = byte
                var bottomFourPixGroup = ""
                for _ in 0 ..< 4 {
                    bottomFourPixGroup += (bottom & 0x01 == 0) ? " " : "*"
                    bottom = bottom >> 1
                }
                
                pixels.append(String(topFourPixGroup.reversed()))
                pixels.append(String(bottomFourPixGroup.reversed()))
            }

            // print top half
            for y in 0 ..< 4 {
                for x in 0 ..< 12 {
                    let index = y + x * 4
                    print(pixels[index], terminator: "")
                }
                print("")
            }

            // print bottom half
            for y in 0 ..< 4 {
                for x in 0 ..< 12 {
                    let index = y + x * 4 + 24*2
                    print(pixels[index], terminator: "")
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
