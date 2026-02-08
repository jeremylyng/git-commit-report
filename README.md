# git-commit-report

Generate detailed markdown commit reports from any git repository. Get a breakdown of commits, file changes, line stats, authors, and associated PRs — all in a clean `.md` file.

## Install

**One-liner:**

```bash
curl -fsSL https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/install.sh | bash
```

**From source:**

```bash
git clone https://github.com/jeremylyng/git-commit-report.git
cd git-commit-report
./install.sh
```

**Manual:**

```bash
cp git-commit-report /usr/local/bin/
chmod +x /usr/local/bin/git-commit-report
```

## Usage

Once installed, it works as a **git subcommand** — just run `git commit-report`:

```bash
# Interactive mode (prompts for repo and period)
git commit-report

# Last 7 days
git commit-report -d 7

# Date range
git commit-report --from 2026-02-01 --to 2026-02-07

# Specific repo
git commit-report -r ~/projects/my-app -d 14

# Custom output filename
git commit-report -d 7 -o weekly-report.md

# Skip git fetch (faster, uses local data)
git commit-report -d 3 --no-fetch
```

### Options

| Flag | Description |
|------|-------------|
| `-d, --days <N>` | Last N days (default: 3) |
| `--from <YYYY-MM-DD>` | Start date (inclusive) |
| `--to <YYYY-MM-DD>` | End date (inclusive, default: today) |
| `-r, --repo <path>` | Path to git repository |
| `-o, --output <file>` | Output filename |
| `--no-fetch` | Skip `git fetch --all` |
| `-h, --help` | Show help |
| `-v, --version` | Show version |

### Output

Generates `COMMIT_REPORT_<from>_<to>.md` with:

- **Summary by Author** — commits, lines added/removed per author
- **All Commits** — grouped by date, with timestamps, file stats, and PR links
- **Summary by PR** — aggregated stats per pull request

### Features

- **Interactive mode** — run without arguments for guided setup
- **Repo selection** — point at any repo with `--repo`, or pick from discovered repos interactively
- **Timezone-aware** — timestamps shown in author's timezone; non-local offsets displayed inline
- **PR detection** — extracts PR numbers from commit messages, or maps branches to PRs via GitHub CLI
- **GitHub links** — automatic PR links when `gh` CLI is available
- **Cross-platform** — works on macOS and Linux

## Requirements

- `git`
- `bash` 3.2+
- `gh` (GitHub CLI) — optional, enables PR title lookup and links

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/install.sh | bash -s -- --uninstall
```

Or just:

```bash
rm /usr/local/bin/git-commit-report
```

## License

MIT
