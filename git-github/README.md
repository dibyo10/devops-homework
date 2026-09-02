# Git and GitHub evidence

The required workflow was performed in this repository rather than copied from an example.

## `git commit -m` versus `git commit -a -m`

- `git commit -m "message"` commits only changes already placed in the index with `git add`.
- `git commit -a -m "message"` first stages modifications and deletions of tracked files, then commits them. It does not add new untracked files.

Observed before the `-a` commit on `git-practice`:

```text
 M git-github/commit-command-practice.txt
?? git-github/untracked-before-commit-a.txt
```

Observed after commit `e44bca6` using `git commit -a -m "Demonstrate commit a behavior"`:

```text
?? git-github/untracked-before-commit-a.txt
```

This proves that the tracked modification was committed while the new file remained untracked.

## Cherry-pick

The exercise started with three commits on `main`:

```text
5a79ffb Document networking commands and observed output
bc1c84e Add Linux fundamentals and system information script
899ee09 Initialize DevOps homework repository
```

Then `git switch -c git-practice` was used and three commits were created:

```text
5335976 Add branch-only Git practice evidence
e44bca6 Demonstrate commit a behavior
0d2b81a Add Git commit command practice file
```

The selected commit was applied to `main`:

```bash
git switch main
git cherry-pick 0d2b81a
```

Git created commit `8d3ae3c` on `main`. `git-github/commit-command-practice.txt` was then present on `main`, while `git-github/branch-only-note.txt` remained absent. A cherry-pick creates a new commit with the selected patch, so its hash differs from the source commit.

Verify:

```bash
git log --oneline --all --graph --decorate
git show --stat 8d3ae3c
git show git-practice:git-github/branch-only-note.txt
test ! -e git-github/branch-only-note.txt
```

