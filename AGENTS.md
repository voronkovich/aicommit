# aicommit

This document provides a comprehensive overview of the `aicommit` project, its structure, and development conventions.

## Project Overview

`aicommit` is a Bash script that automates the creation of commit messages using AI. It integrates with `git` to analyze staged changes and generate commit messages that adhere to the Conventional Commits specification. The script is designed to be flexible, allowing users to configure the AI model and customize commit message rules.

### Key Features

*   **AI-Powered Commit Messages:** Leverages AI models to generate commit messages.
*   **Conventional Commits:** Enforces the Conventional Commits standard for consistent and readable git history.
*   **Git Integration:** Automatically stages changes if none are staged and can initialize a git repository.
*   **Customizable:** Users can define their own commit message rules via a `COMMITS.md` file and specify a custom AI command using the `AICOMMIT_CMD` environment variable.

## Building and Running

`aicommit` is a standalone Bash script and does not require a build process.

### Running the script

To run the script, simply execute it from the command line:

```bash
./aicommit
```

### Running Tests

The project uses `shellspec` for testing. To run the tests, execute the following command:

```bash
shellspec
```

## Development Conventions

### Coding Style

The project follows the Google Shell Style Guide. When contributing, please adhere to these conventions.

### Testing

All new features and bug fixes should be accompanied by tests. The tests are located in the `spec` directory and are written using the `shellspec` framework.

### Commit Messages

Commit messages should follow the Conventional Commits specification. This is enforced by the `aicommit` script itself.
