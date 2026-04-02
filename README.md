# aicommit

[![CI](https://github.com/voronkovich/aicommit/actions/workflows/test.yml/badge.svg)](https://github.com/voronkovich/aicommit/actions/workflows/test.yml)

A simple Bash script that generates AI-powered commit messages in [Conventional Commits](https://www.conventionalcommits.org) format.

## Features

- **AI-Powered**: Uses AI models (default: [gemini](https://geminicli.com/)) to analyze your staged changes and generate meaningful commit messages
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
```

## Configuration

Set the `AICOMMIT_CMD` environment variable to use a different AI model:

```bash
export AICOMMIT_CMD="qwen --prompt"
export AICOMMIT_CMD="aichat --prompt"
export AICOMMIT_CMD="llm -m claude-4-opus"
```

Default: `gemini --prompt`

## Conventional Commits Format

Generated commit messages follow this format:

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
