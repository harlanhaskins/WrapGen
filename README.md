# WrapGen

WrapGen generates Swifty wrappers for C enums. It has a built-in recognizer for
libclang-style enums.

# Usage

```
WrapGen --file /path/to/C/file.h --symbol CXNameOfEnumInLibClang --name IntendedNameOfEnumInSwift --type [enum|options|structs]
```

I'd recommend playing around with the flags for a bit to see what you want to
generate.

# Author

Harlan Haskins ([@harlanhaskins](https://github.com/harlanhaskins))

# License

WrapGen is released under the MIT license, a copy of which is available in this
repo.
