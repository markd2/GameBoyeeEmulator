import Foundation
import ArgumentParser

@main
struct gbee: ParsableCommand {
    @Argument(help: "Rom File to dump")
    var romFilePath: String

    mutating func run() throws {
        let romFile = try RomFile(fileLocation: URL(filePath: self.romFilePath))
        romFile.splunge()
    }
}
