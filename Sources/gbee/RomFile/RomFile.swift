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
        print("Splunge")
    }
}
