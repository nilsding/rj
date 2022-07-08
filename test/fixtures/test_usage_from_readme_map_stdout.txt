reading from stdin
running 1 expressions
----> item = (item.map { |item| { one: item["foo"], two: item.dig("bar", "name") } })
printing item
[
  {
    "one": true,
    "two": "Bugs"
  },
  {
    "one": false,
    "two": "Features"
  },
  {
    "one": true,
    "two": "Ruby"
  },
  {
    "one": true,
    "two": "FooBar"
  },
  {
    "one": false,
    "two": "High5"
  }
]
