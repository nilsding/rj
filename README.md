# rj

a tool that's like `jq` but uses Ruby expressions

## Usage

```sh
# get the first element of an array (Enumerable#first)
tool_that_emits_json | rj '.first'

# get the 3rd element (Array#[])
tool_that_emits_json | rj '[2]'

# get specific fields (Hash#slice)
tool_that_emits_json | rj '.first.slice("foo", "bar")'

# or map them yourself, the second expression will be applied to the result
# of the first.  'item' is the special variable that holds the previous
# result
# this also demonstrates the usage of Hash#dig to fetch nested elements
tool_that_emits_json | rj '.first' '{ one: item["foo"], two: item.dig("bar", "name") }'

# same as above, but for all elements (Enumerable#map)
tool_that_emits_json | rj '.map { |item| { one: item["foo"], two: item.dig("bar", "name") } }'

# instead of `[]` and `dig` you can access an object's fields like methods
# too.
# this only works with keys that aren't already methods (e.g. `first`, `dig`,
# `slice`, ...), and only on objects -- arrays need to be accessed like '[0]'.
tool_that_emits_json | rj '.map { |item| { one: item.foo, two: item.bar.name } }'
```

## Requirements

for building:
- CMake
- Ruby 2.5 or later
- [whatever else mruby 3.2.0 needs][mruby_deps] :^)

## Building

```sh
# configure it
cmake --preset dev

# compile it
cmake --build --preset dev

# test it
ruby ./test/rj_test.rb

# run it
./build/src/rj
```

[mruby_deps]: https://github.com/mruby/mruby/blob/3.2.0/doc/guides/compile.md#prerequisites
