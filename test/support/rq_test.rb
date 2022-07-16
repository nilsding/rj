require 'minitest/autorun'

require_relative './fixtures'
require_relative './rq_runner'

class RqTest < ::Minitest::Test
  # Defines a basic test case that runs rq with a given `argv` and `stdin`, and
  # asserts the results of `status`, `stderr`, and `stdout`.
  #
  # The name of the test method is the underscored name of the test class
  # (excluding any "Test" suffix or prefix) combined with the value of the
  # `name` parameter prefixed with `"test_"`.  e.g. `rq_test! :foo` inside the
  # `TestBasicObject` or `BasicObjectTest` class would define a test method
  # called `test_basic_object_foo`.
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
    underscored_class_name = self.name
      .gsub(/^Test|Test$/, '') # get rid of "Test" in the class name
      .gsub(/(.)([A-Z])/, '\1_\2')
      .downcase
    define_method :"test_#{underscored_class_name}_#{name}" do
      if ENV["OUTPUT_ONLY"]
        puts "\033[34;1m"
        header = "Test: #{__method__} "
        header += ('=' * (79 - header.length))
        puts header
      end
      stdin = JsonFixtures.fetch(stdin) if stdin.is_a?(Symbol)

      unless ENV["RECORD"] || ENV["OUTPUT_ONLY"]
        stderr = StderrFixtures.fetch(__method__) if stderr == :from_fixture
        stderr = StderrFixtures.fetch(stderr) if stderr.is_a?(Symbol)

        stdout = StdoutFixtures.fetch(__method__) if stdout == :from_fixture
        stdout = StdoutFixtures.fetch(stdout) if stdout.is_a?(Symbol)
      end

      if ENV["OUTPUT_ONLY"]
        print "\033[0mRunning:\033[32;1m "
        print "rq \033[35;1m"
        puts argv.join(" ")
      end
      rq = RqRunner.new(argv: argv, stdin: stdin)
      rq.run

      if ENV["OUTPUT_ONLY"]
        puts "\033[0mstderr:\033[31;1m"
        puts rq.stderr
        puts "\033[0mstdout:\033[33;1m"
        puts rq.stdout
        puts "\033[0mexit status: #{rq.status}"
        puts
        puts
        return
      end

      if ENV["RECORD"]
        if stderr == :from_fixture
          File.open(File.expand_path("../fixtures/#{__method__}_stderr.txt", __dir__), 'w') do |f|
            f.write rq.stderr
          end
          stderr = rq.stderr
        end
        if stdout == :from_fixture
          File.open(File.expand_path("../fixtures/#{__method__}_stdout.txt", __dir__), 'w') do |f|
            f.write rq.stdout
          end
          stdout = rq.stdout
        end
      end

      assert_equal rq.status, status, ["exit status", msg].compact.join(": ")
      assert_equal rq.stderr, stderr, ["stderr", msg].compact.join(": ")
      assert_equal rq.stdout, stdout, ["stdout", msg].compact.join(": ")
    end
  end
end
