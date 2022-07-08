# rq

a tool that's like `jq` but uses Ruby expressions

## Usage

```sh
# get the first element of an array (Enumerable#first)
tool_that_emits_json | rq '.first'

# get the 3rd element (Array#[])
tool_that_emits_json | rq '[2]'

# get specific fields (Hash#slice)
tool_that_emits_json | rq '.first.slice("foo", "bar")'

# or map them yourself, the second expression will be applied to the result
# of the first.  'item' is the special variable that holds the previous
# result
# this also demonstrates the usage of Hash#dig to fetch nested elements
tool_that_emits_json | rq '.first' '{ one: item["foo"], two: item.dig("bar", "name") }'

# same as above, but for all elements (Enumerable#map)
tool_that_emits_json | rq '.map { |item| { one: item["foo"], two: item.dig("bar", "name") } }'
```

## Requirements

for building:
- CMake
- Ruby 2.5 or later
- [whatever else mruby 3.1.0 needs][mruby_deps] :^)

## Building

```sh
# configure it
cmake --preset dev

# compile it
cmake --build --preset dev

# run it
./build/src/rq
```

[mruby_deps]: https://github.com/mruby/mruby/blob/3.1.0/doc/guides/compile.md#prerequisites
