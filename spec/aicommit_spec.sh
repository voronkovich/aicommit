Describe 'aicommit --help'
  It 'displays help message'
    When call ./aicommit --help
    The status should be success
    The output should include 'Usage: aicommit [options]'
  End
End
