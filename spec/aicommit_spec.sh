Describe 'aicommit'
  It 'displays help message for -h'
    When call ./aicommit --help
    The status should be success
    The output should include 'Usage: aicommit [options]'
  End

  It 'displays help message for --help'
    When call ./aicommit -h
    The status should be success
    The output should include 'Usage: aicommit [options]'
  End

  It 'fails with error message for unknown option'
    When call ./aicommit --foo
    The status should be failure
    The stderr should include "unknown option '--foo'"
    The stderr should include "Try 'aicommit --help' for more information."
  End
End
