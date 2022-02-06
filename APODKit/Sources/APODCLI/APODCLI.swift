import ArgumentParser

@main
enum AsyncApod: AsyncMain {
    typealias Command = Apod
}

struct Apod: AsyncParsableCommand {

    @Argument(help: "Date in format YYYY-MM-DD to look up.")
    var dateString: String

    mutating func run() async throws {
        let apodExec = APODExec()

        let outputString = try await apodExec.apodString(for: dateString)
        print(outputString)
    }
}
