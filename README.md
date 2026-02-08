# git-commit-report

Generate detailed commit reports from any git repository. Get a breakdown of commits, file changes, line stats, authors, and associated PRs — output as markdown, JSON, or CSV.

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

**Custom install directory:**

```bash
./install.sh --prefix ~/.local/bin
```

**Manual:**

```bash
cp git-commit-report /usr/local/bin/
chmod +x /usr/local/bin/git-commit-report
```

> **Tip:** Add `COMMIT_REPORT_*.md` to your `.gitignore` to avoid accidentally committing generated reports.

## Usage

Once installed, it works as a **git subcommand** — just run `git commit-report`:

```bash
# Interactive mode (prompts for repo and period)
git commit-report

# Last 7 days
git commit-report -d 7

# Filter by author
git commit-report --author "Jeremy" -d 14

# Date range
git commit-report --from 2026-02-01 --to 2026-02-07

# Specific repo
git commit-report -r ~/projects/my-app -d 14

# Custom output filename
git commit-report -d 7 -o weekly-report.md

# Output to a specific directory
git commit-report -d 7 --output-dir ~/reports

# JSON output to stdout (great for piping)
git commit-report --format json --stdout

# CSV output
git commit-report --format csv -d 7

# Filter to a specific branch, no merge commits
git commit-report --branch main --no-merges -d 7

# Quiet mode (no progress output)
git commit-report -q -d 3

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
| `-o, --output <file>` | Output filename (`-o -` for stdout) |
| `--stdout` | Write report to stdout instead of file |
| `--output-dir <path>` | Directory for output file (default: repo root) |
| `--author <name>` | Filter commits by author |
| `-b, --branch <name>` | Filter to specific branch (default: all) |
| `--format <fmt>` | Output format: `markdown` (default), `json`, `csv` |
| `--no-merges` | Exclude merge commits |
| `--pr-limit <N>` | Max PRs to fetch for mapping (default: 100) |
| `-q, --quiet` | Suppress progress output |
| `--no-footer` | Omit footer branding from report |
| `--no-fetch` | Skip `git fetch --all` |
| `--check-update` | Check if a newer version is available |
| `-h, --help` | Show help |
| `-v, --version` | Show version |

### Output

Generates `COMMIT_REPORT_<from>_<to>.<ext>` with:

- **Summary by Author** — commits, lines added/removed per author
- **All Commits** — grouped by date, with timestamps, file stats, and PR links
- **Summary by PR** — aggregated stats per pull request

Output format depends on `--format`: `.md` (default), `.json`, or `.csv`.

### Features

- **Interactive mode** — run without arguments for guided setup
- **Repo selection** — point at any repo with `--repo`, or pick from discovered repos interactively
- **Author & branch filtering** — generate reports for specific people or branches
- **Multiple output formats** — markdown, JSON, and CSV
- **Stdout support** — pipe output to other tools with `--stdout`
- **Configurable output directory** — write reports anywhere with `--output-dir`
- **Timezone-aware** — timestamps shown in author's timezone; non-local offsets displayed inline
- **PR detection** — extracts PR numbers from commit messages, or maps branches to PRs via GitHub CLI
- **Multi-forge links** — automatic PR/MR links for GitHub, GitLab, and Bitbucket
- **Config files** — set defaults per-user or per-repo
- **Cross-platform** — works on macOS and Linux

## Configuration

You can set default options via config files and environment variables, so you don't have to repeat flags every time.

**Precedence** (highest wins): CLI flags > environment variables > repo config > user config > defaults

### Config files

Create `~/.git-commit-reportrc` for user-wide defaults, or `<repo>/.git-commit-reportrc` for per-repo settings. Format is `key=value`, one per line:

```ini
# ~/.git-commit-reportrc
days=7
author=Jeremy
output_dir=~/reports
format=markdown
quiet=false
no_footer=false
no_fetch=false
no_merges=false
pr_limit=200
search_dirs=~/Documents:~/Projects:~/code
```

### Environment variables

All settings can be overridden with `GIT_COMMIT_REPORT_*` environment variables:

| Variable | Description |
|----------|-------------|
| `GIT_COMMIT_REPORT_DAYS` | Default number of days |
| `GIT_COMMIT_REPORT_AUTHOR` | Default author filter |
| `GIT_COMMIT_REPORT_OUTPUT_DIR` | Default output directory |
| `GIT_COMMIT_REPORT_FORMAT` | Default output format |
| `GIT_COMMIT_REPORT_QUIET` | Suppress progress (`true`/`false`) |
| `GIT_COMMIT_REPORT_NO_FOOTER` | Omit footer (`true`/`false`) |
| `GIT_COMMIT_REPORT_NO_FETCH` | Skip fetch (`true`/`false`) |
| `GIT_COMMIT_REPORT_NO_MERGES` | Exclude merges (`true`/`false`) |
| `GIT_COMMIT_REPORT_BRANCH` | Default branch filter |
| `GIT_COMMIT_REPORT_PR_LIMIT` | PR lookup limit |
| `GIT_COMMIT_REPORT_SEARCH_DIRS` | Colon-separated search paths for interactive repo discovery |

### Config keys

| Key | CLI equivalent | Default |
|-----|---------------|---------|
| `days` | `-d, --days` | `3` |
| `author` | `--author` | *(all)* |
| `output_dir` | `--output-dir` | *(repo root)* |
| `format` | `--format` | `markdown` |
| `quiet` | `-q, --quiet` | `false` |
| `no_footer` | `--no-footer` | `false` |
| `no_fetch` | `--no-fetch` | `false` |
| `no_merges` | `--no-merges` | `false` |
| `branch` | `-b, --branch` | *(all)* |
| `pr_limit` | `--pr-limit` | `100` |
| `search_dirs` | — | *(built-in defaults)* |

## Requirements

- `git`
- `bash` 3.2+
- `gh` (GitHub CLI) — optional, enables PR title lookup and links for GitHub repos

## Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/jeremylyng/git-commit-report/main/install.sh | bash -s -- --uninstall
```

Or specify the install location:

```bash
./install.sh --prefix ~/.local/bin --uninstall
```

Or just remove the binary directly:

```bash
rm /usr/local/bin/git-commit-report
```

## License

MIT
