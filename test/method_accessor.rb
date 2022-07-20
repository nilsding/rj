require_relative './support/rj_test'

# Tests for the method navigation syntax.
class MethodAccessor < RjTest
  rj_test! :deep_dive,
      argv: [
        '.data.children[0].data.slice(*%w[id title url_overridden_by_dest])',
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :mapping_methods,
      argv: [
        '.data.children.map(&:data).map(&:id)',
      ],
      stdin:  :reddit_trashpandas,
      stdout: :from_fixture

  rj_test! :bool,
      argv: [
        '.falsy',
      ],
      stdin: '{"falsy": false}',
      stdout: "false\n"

  rj_test! :bool_symbol,
      argv: [
        '{:falsy => false}',
        '.falsy',
      ],
      stdin: '{}',
      stdout: "false\n"
end
