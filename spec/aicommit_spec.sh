Describe 'aicommit'
  BeforeAll PATH="${PWD}:$PATH"

  setup_no_repo_dir() {
    export TEST_DIR="$(mktemp -d)"
    cd "${TEST_DIR}"
  }

  cleanup_test_dir() {
    if [[ -n "${TEST_DIR:-}" && -d "${TEST_DIR}" ]]; then
      rm -rf "${TEST_DIR}"
    fi
  }

  It 'displays help message for -h'
    When call aicommit --help
    The status should be success
    The output should include 'Usage: aicommit [options]'
  End

  It 'displays help message for --help'
    When call aicommit -h
    The status should be success
    The output should include 'Usage: aicommit [options]'
  End

  It 'fails with error message for unknown option'
    When call aicommit --foo
    The status should be failure
    The stderr should include "unknown option '--foo'"
    The stderr should include "Try 'aicommit --help' for more information."
  End

  It 'initializes a new git repo when user confirms'
    BeforeCall setup_no_repo_dir
    AfterCall cleanup_test_dir
    Data
      #|y
    End
    When call aicommit
    The status should be failure
    The output should include "Not a git repository. Initialize a new one?"
    The output should include "Initializing new git repository..."
    The path "${TEST_DIR}/.git" should be directory
    The stderr should include "No changes to commit at all."
  End

  It 'fails when user declines to initialize git repo'
    BeforeCall setup_no_repo_dir
    AfterCall cleanup_test_dir
    Data
      #|n
    End
    When call aicommit
    The status should be failure
    The output should include "Not a git repository. Initialize a new one?"
    The path "${TEST_DIR}/.git" should not be directory
    The stderr should include "Git repository not initialized."
  End
End
