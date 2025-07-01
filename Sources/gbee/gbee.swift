import Foundation
import ArgumentParser

@main
struct gbee: ParsableCommand {
    @Argument(help: "Rom File to dump")
    var romFilePath: String

    mutating func run() throws {
        let data = try Data(contentsOf: URL(filePath: romFilePath))
        print(data.count)
    }
}
