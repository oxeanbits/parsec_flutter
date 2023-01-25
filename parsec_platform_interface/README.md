# parsec_platform_interface

A common platform interface for the [`parsec`][1] plugin.

This interface allows platform-specific implementations of the `parsec` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

## Usage

To implement a new platform-specific implementation of `parsec`, extend
[`ParsecPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`ParsecPlatform` by calling
`ParsecPlatform.instance = MyParsec()`.

[1]: ../parsec/
[2]: lib/parsec_platform_interface.dart
