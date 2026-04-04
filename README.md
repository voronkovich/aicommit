# aicommit

[![CI](https://github.com/voronkovich/aicommit/actions/workflows/test.yml/badge.svg)](https://github.com/voronkovich/aicommit/actions/workflows/test.yml)

A simple Bash script that generates AI-powered commit messages in [Conventional Commits](https://www.conventionalcommits.org) format.

## Features

- **AI-Powered**: Uses external AI CLI tools (default: [gemini](https://geminicli.com/)) to analyze your staged changes and generate meaningful commit messages. It does not make direct API calls.
- **Conventional Commits**: Follows the Conventional Commits specification for consistent commit messages
- **Auto-Stage**: Automatically stages all changes if none are currently staged
- **Git Repo Init**: Can initialize a new git repository if you're not in one
- **Configurable AI**: Use different AI models via the `AICOMMIT_CMD` environment variable

## Installation

1. Download the `aicommit` script to your system
2. Make it executable: `chmod +x aicommit`
3. Place it in your PATH or use it directly

### Quick Install to ~/.local/bin

```bash
wget -O ~/.local/bin/aicommit https://raw.githubusercontent.com/voronkovich/aicommit/main/aicommit &&
    chmod +x ~/.local/bin/aicommit
```

Ensure `~/.local/bin` is in your PATH.

## Usage

```bash
# Generate and commit with AI message
aicommit

# Show help
aicommit --help

# Show current settings (AI command, COMMITS.md path, and prompt)
aicommit --info
```

## Configuration

Set the `AICOMMIT_CMD` environment variable to use a different AI model:

```bash
export AICOMMIT_CMD="qwen --prompt"
export AICOMMIT_CMD="aichat --prompt"
export AICOMMIT_CMD="llm -m claude-4-opus"
```

Default: `gemini --prompt`

## Custom Commit Rules

You can customize the AI prompt used for generating commit messages by creating a `COMMITS.md` file. This file allows you to define specific rules, guidelines, or examples that the AI should follow.

The `aicommit` script searches for `COMMITS.md` in the following order of precedence:

1.  **Project Root**: `./COMMITS.md` (specific to the current repository)
2.  **User Home Directory**: `~/COMMITS.md` (global for the current user)
3.  **User Config Directory**: `~/.config/COMMITS.md` (global for the current user)

The first `COMMITS.md` file found will be used. If no `COMMITS.md` file is found, the script defaults to the Conventional Commits specification.

### `COMMITS.md` Example

```markdown
Use [Conventional Commits](https://www.conventionalcommits.org/) format:

- **Type**: Must be one of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`.
- **Scope (optional)**: Describe the part of the codebase affected.
- **Description**: Imperative mood, lowercase, no period, under 72 characters.

Examples:
- feat: add user authentication module
- fix(api): resolve null pointer exception in login endpoint
- docs: update installation instructions
- refactor: simplify database connection logic
```

To easily create a sample `COMMITS.md` file with default Conventional Commits rules in your project root, use the `--init-commits` option:

```bash
aicommit --init-commits
```

## Conventional Commits Format

Generated commit messages follow [this format](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>
```

**Types**: feat, fix, docs, style, refactor, perf, test, chore

**Rules**:
- Imperative mood, lowercase, no period
- Under 72 characters
- Scope used only when relevant

## Examples

```
feat: add user authentication module
fix(api): resolve null pointer exception in login endpoint
docs: update installation instructions
refactor: simplify database connection logic
```

## License

Copyright (c) Voronkovich Oleg. Distributed under the [MIT](LICENSE).
