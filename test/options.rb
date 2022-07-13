require_relative './support/rq_test'

class Options < RqTest
  rq_test! :help,
      argv: ["-h"],
      stdout: :from_fixture

  rq_test! :long_help,
      argv: ["--help"],
      stdout: :test_options_help

  rq_test! :separate_help_version,
      argv: ["-v", "-h"],
      stdout: :test_options_help,
      msg: "getting help is more important"

  rq_test! :combined_help_version,
      argv: ["-vh"],
      stdout: :test_options_help,
      msg: "getting help is more important"

  rq_test! :separate_long_help_version,
      argv: ["--version", "--help"],
      stdout: :test_options_help,
      msg: "getting help is more important"

  rq_test! :version,
      argv: ["-v"],
      stdout: :from_fixture

  rq_test! :long_version,
      argv: ["--version"],
      stdout: :test_options_version

  rq_test! :unknown,
      argv: ["-U"],
      status: 1,
      stderr: :from_fixture
end
