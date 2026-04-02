Describe 'aicommit'
  export TEST_DIR=""

  BeforeAll PATH="${PWD}:$PATH"
  AfterEach cleanup

  cleanup() {
    if [[ -n "${TEST_DIR:-}" && -d "${TEST_DIR}" ]]; then
      rm -rf "${TEST_DIR}"
    fi
  }

  setup_test_dir() {
    TEST_DIR="$(mktemp -d)" && cd "${TEST_DIR}"
  }

  setup_no_repo_dir() {
    setup_test_dir
  }

  setup_repo_with_changes() {
    setup_test_dir
    git init
    git branch -M main
    echo "hello" > file.txt
    git add file.txt
  } >/dev/null

  setup_empty_repo() {
    setup_test_dir
    git init
    git branch -M main
  } >/dev/null

  setup_repo_with_unstaged_changes() {
    setup_test_dir
    git init
    git branch -M main
    echo "initial" > init.txt
    git add init.txt
    git commit -m "initial commit"
    echo "hello" > file.txt
  } >/dev/null

  setup_repo_with_deleted_file() {
    setup_test_dir
    git init
    git branch -M main
    echo "hello" > file.txt
    git add file.txt
    git commit -m "add file"
    rm file.txt
  } >/dev/null

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
    setup_no_repo_dir
    Data
      #|y
    End
    When call aicommit
    The status should be failure
    The output should include "Not a git repository. Initialize a new one?"
    The output should include "Initializing new git repository..."
    The path ".git" should be directory
    The stderr should include "No changes to commit at all."
  End

  It 'fails when user declines to initialize git repo'
    setup_no_repo_dir
    Data
      #|n
    End
    When call aicommit
    The status should be failure
    The output should include "Not a git repository. Initialize a new one?"
    The path ".git" should not be directory
    The stderr should include "Git repository not initialized."
  End

  It 'fails when AI command returns empty commit message'
    setup_repo_with_changes
    When call env AICOMMIT_CMD=true aicommit
    The status should be failure
    The output should include "Generating commit message..."
    The stderr should include "Failed to generate commit message."
  End

  It 'fails when there are no changes to commit'
    setup_empty_repo
    When call aicommit
    The status should be failure
    The output should include "No staged changes found. Adding all changes..."
    The stderr should include "No changes to commit at all."
  End

  It 'auto-stages changes and commits with AI message'
    setup_repo_with_unstaged_changes
    Mock aicustomcmd
      echo "feat: add file"
    End
    export AICOMMIT_CMD=aicustomcmd
    When call aicommit
    The status should be success
    The output should include "No staged changes found. Adding all changes..."
    The output should include "Generating commit message..."
    The output should include "feat: add file"
  End

  It 'commits with staged changes and AI message'
    setup_repo_with_changes
    Mock aicustomcmd
      echo "feat: add hello"
    End
    export AICOMMIT_CMD=aicustomcmd
    When call aicommit
    The status should be success
    The output should include "Generating commit message..."
    The output should include "feat: add hello"
  End

  It 'auto-stages deleted file and commits'
    setup_repo_with_deleted_file
    Mock aicustomcmd
      echo "chore: remove file"
    End
    export AICOMMIT_CMD=aicustomcmd
    When call aicommit
    The status should be success
    The output should include "No staged changes found. Adding all changes..."
    The output should include "chore: remove file"
  End
End
