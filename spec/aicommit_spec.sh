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

  setup_repo_with_changes() {
    export TEST_DIR="$(mktemp -d)"
    cd "${TEST_DIR}"
    git init
    git branch -M main
    echo "hello" > file.txt
    git add file.txt
  }

  setup_empty_repo() {
    export TEST_DIR="$(mktemp -d)"
    cd "${TEST_DIR}"
    git init
    git branch -M main
  }

  setup_repo_with_unstaged_changes() {
    export TEST_DIR="$(mktemp -d)"
    cd "${TEST_DIR}"
    git init
    git branch -M main
    echo "initial" > init.txt
    git add init.txt
    git commit -m "initial commit"
    echo "hello" > file.txt
  }

  setup_repo_with_deleted_file() {
    export TEST_DIR="$(mktemp -d)"
    cd "${TEST_DIR}"
    git init
    git branch -M main
    echo "hello" > file.txt
    git add file.txt
    git commit -m "add file"
    rm file.txt
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

  It 'fails when AI command returns empty commit message'
    BeforeCall setup_repo_with_changes
    AfterCall cleanup_test_dir
    When call env AICOMMIT_CMD=true aicommit
    The status should be failure
    The output should include "Generating commit message..."
    The stderr should include "Failed to generate commit message."
  End

  It 'fails when there are no changes to commit'
    BeforeCall setup_empty_repo
    AfterCall cleanup_test_dir
    When call aicommit
    The status should be failure
    The output should include "No staged changes found. Adding all changes..."
    The stderr should include "No changes to commit at all."
  End

  It 'auto-stages changes and commits with AI message'
    BeforeCall setup_repo_with_unstaged_changes
    AfterCall cleanup_test_dir
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
    BeforeCall setup_repo_with_changes
    AfterCall cleanup_test_dir
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
    BeforeCall setup_repo_with_deleted_file
    AfterCall cleanup_test_dir
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
