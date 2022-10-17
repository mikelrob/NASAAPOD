# NASAAPOD

Interacting with the NASA Astronomy Picture of the Day API

## Usage

The xcode workspace contains an iOS App in the APOD direct and a Swift Package in the APODKit directory.

Open the workspace from the terminal with `open APOD.xcworkspace/`

Run the CLI for the Swift Package from the terminal with:

```
cd APODKit
swift build
swift build --show-bin-path
```

run the command `./apod`

## Testing

There are some tests for the interface to the `APODKitLib`. They can be run from Xcode or from the terminal with

```
cd APODKit
swift test
```
