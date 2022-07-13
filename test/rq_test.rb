require 'minitest/autorun'
require 'open3'

# Hash containing all JSON fixtures that can be passed to rq's stdin during testing
JsonFixtures = Dir[File.expand_path("./fixtures/*.json", __dir__)].map do |fn|
  [File.basename(fn, ".json").to_sym, File.read(fn)]
end.to_h

# Hash containing the expected stdout
StdoutFixtures = Dir[File.expand_path("./fixtures/*_stdout.txt", __dir__)].map do |fn|
  [File.basename(fn, "_stdout.txt").to_sym, File.read(fn)]
end.to_h

# Hash containing the expected stderr
StderrFixtures = Dir[File.expand_path("./fixtures/*_stderr.txt", __dir__)].map do |fn|
  [File.basename(fn, "_stderr.txt").to_sym, File.read(fn)]
end.to_h

class RqRunner
  RQ_BIN = ENV["RQ_BIN"] || File.expand_path("../build/src/rq", __dir__)

  attr_reader :argv, :stdin, :stdout, :stderr, :status

  def initialize(argv: [], stdin: nil)
    @argv = argv
    @stdin = stdin
  end

  def run
    @stdout, @stderr, process = Open3.capture3(*[RQ_BIN, *argv], stdin_data: stdin)
    @status = process.exitstatus
  end
end

class RqTest < ::Minitest::Test
  # Defines a basic test case that runs rq with a given `argv` and `stdin`, and
  # asserts the results of `status`, `stderr`, and `stdout`.
  #
  # The name of the test method is the value of the `name` parameter prefixed
  # with `"test_"`.  e.g. `rq_test! :basic_object` would define a test method
  # called `test_basic_object`.
  #
  # If `stdin`, `stderr`, or `stdout` are a Symbol the fixture with the
  # corresponding name will be used for the test.
  #
  # Additionally `stderr` and `stdout` can be set to `:from_fixture` if you
  # want to use the test method's name as the fixture identifier.  e.g. for
  # a `rq_test! :basic_object, stderr: :from_fixture` will use the
  # `"test_basic_object_stdout.txt"` fixture.
  #
  # `msg` is an optional message that will be shown on assertion failures.
  def self.rq_test!(name, argv: [], stdin: nil, status: 0, stderr: "", stdout: "", msg: nil)
    define_method :"test_#{name}" do
      stdin = JsonFixtures.fetch(stdin) if stdin.is_a?(Symbol)

      stderr = StderrFixtures.fetch(__method__) if stderr == :from_fixture
      stderr = StderrFixtures.fetch(stderr) if stderr.is_a?(Symbol)

      stdout = StdoutFixtures.fetch(__method__) if stdout == :from_fixture
      stdout = StdoutFixtures.fetch(stdout) if stdout.is_a?(Symbol)

      rq = RqRunner.new(argv: argv, stdin: stdin)
      rq.run

      assert_equal rq.status, status, ["exit status", msg].compact.join(": ")
      assert_equal rq.stderr, stderr, ["stderr", msg].compact.join(": ")
      assert_equal rq.stdout, stdout, ["stdout", msg].compact.join(": ")
    end
  end

  rq_test! :basic_object,
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :basic_object_languages,
      argv: [
        '["languages"]',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :basic_object_languages_select,
      argv: [
        '["languages"]',
        '.select { |lang| %w[C++ Ruby].include?(lang) }'
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :basic_object_return_string,
      argv: [
        '["location"]',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :basic_object_return_object,
      argv: [
        '{ location: item["location"], short_location: item["location"].upcase[0..1] }',
      ],
      stdin:  :basic_object,
      stdout: :from_fixture

  rq_test! :basic_object_error,
      argv: [
        '.unknown_method',
      ],
      stdin:  :basic_object,
      status: 1,
      stderr: :from_fixture,
      stdout: :from_fixture

  rq_test! :usage_from_readme_first_element,
      argv: [
        '.first',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :usage_from_readme_third_element,
      argv: [
        '[2]',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :usage_from_readme_specific_fields,
      argv: [
        '.first.slice("foo", "bar")',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :usage_from_readme_two_expressions,
      argv: [
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :usage_from_readme_map,
      argv: [
        '.map { |item| { one: item["foo"], two: item.dig("bar", "name") } }'
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :debug_flag_start,
      argv: [
        '-d',
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
      ],
      stdin:  :basic_array,
      stdout: :test_usage_from_readme_two_expressions,
      stderr: :from_fixture

  rq_test! :debug_flag_middle,
      argv: [
        '.first',
        '-d',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
      ],
      stdin:  :basic_array,
      stdout: :test_usage_from_readme_two_expressions,
      stderr: :test_debug_flag_start

  rq_test! :debug_flag_end,
      argv: [
        '.first',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
        '-d',
      ],
      stdin:  :basic_array,
      stdout: :test_usage_from_readme_two_expressions,
      stderr: :test_debug_flag_start

  rq_test! :debug_flag_after_two_dashes,
      argv: [
        '.first',
        '--',
        '-d',
        '{ one: item["foo"], two: item.dig("bar", "name") }',
      ],
      stdin:  :basic_array,
      status: 1,
      stderr: :from_fixture

  rq_test! :compact_option,
      argv: [
        '-c',
      ],
      stdin:  :basic_array,
      stdout: :from_fixture

  rq_test! :internals_noflags,
      argv: [
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rq_test! :internals_compact,
      argv: [
        '-c',
        '--',
        'Rq.__debug_info',
      ],
      stdin:  "{}",
      stdout: :from_fixture

  rq_test! :help_option,
      argv: ["-h"],
      stdout: :from_fixture

  rq_test! :long_help_option,
      argv: ["--help"],
      stdout: :test_help_option

  rq_test! :separate_help_version_options,
      argv: ["-v", "-h"],
      stdout: :test_help_option,
      msg: "getting help is more important"

  rq_test! :combined_help_version_options,
      argv: ["-vh"],
      stdout: :test_help_option,
      msg: "getting help is more important"

  rq_test! :separate_long_help_version_options,
      argv: ["--version", "--help"],
      stdout: :test_help_option,
      msg: "getting help is more important"

  rq_test! :version_option,
      argv: ["-v"],
      stdout: :from_fixture

  rq_test! :long_version_option,
      argv: ["--version"],
      stdout: :test_version_option

  rq_test! :unknown_option,
      argv: ["-U"],
      status: 1,
      stderr: :from_fixture
end
