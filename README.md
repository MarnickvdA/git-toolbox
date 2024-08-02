# git-toolbox

Collection of useful git commands and tricks. Always good to have them ready.

`Disclaimer` : The following commands have only been tested with MacOS using the Z shell (zsh).

## Tips

### Enabling Rerere

`git config --global rerere.enabled true`

**Description**: Enable Reuse Recorded Resolution which is especially useful when working in a codebase with other collaborators. It will store how conflict resolution has been done for a specific conflict so the next time a rebase is done, these conflicts are automatically resolved. Legend says this is one of the most common problems why people hate rebasing. Skill issues, perhaps.

## Commands

I've gathered the following aliases that combine some git commands which I find useful. You can see the more detailed description in each of the subsections below. Copy-paste the alias command in your terminal and you should be ready to go :)

- `git oopsie`
- `git new $branch-name`
- `git del $branch-name`
- `git prune-branches`
- `git graph`
- `git stats [$author-name]`
- `git find-branch $search-string`

### Squashing commits on branch

`git rebase -i HEAD~N`, where `N` is the amount of commits that need to be rebased.

**Description**: This command will open up your editor of choice, and this is where you should change all entries of `pick` to `squash` expect the first entry.

> `TODO`
>
> Create shortcut to squash all commits until the place where the branch based of the parent branch.

### `oopsie` reverts the last pushed commit

```sh
git config --global alias.oopsie '!f() { 
  echo "\033[1;33mDANGER! You sure you want to rewrite remote history? (y/n): \033[0m\c"
  read confirm
  if [ "$confirm" != "y" ]; then 
    echo "Operation aborted."; 
    exit 0; 
  fi; 
  
  git reset --soft HEAD~1
  git stash
  git push -f
  git stash pop
}; f'
```

`CAUTION` Only use this one on your own branches, not main or master or another collaborative branch where people have also 'their' version of the branch. Or if you think you know your shit, do it on the default branch and let the world burn!

### `new` Fast branch creation

```sh
git config --global alias.new 'switch -c'
```

**Description**: Yes, I'm this lazy.

### `del` Fast branch deletion

```sh
git config --global alias.del '!f() { 
  git switch -; 
  git branch -D $1; 
}; f'
```

**Description**: Yes, I'm this lazy.

### `prune-branches` Fast branch pruning

```sh
git config --global alias.prune-branches '!f() { 
  git switch main && git fetch -p && 
  for branch in $(git branch -vv | grep ": gone]" | awk '"'"'{print $1}'"'"'); do 
    echo "Deleting branch $branch"; 
    git branch -d "$branch"; 
  done; 
}; f'
```

### `graph` Show Git Repository Graph

```sh
git config --global alias.graph 'log --graph --oneline --decorate --branches --tags'
```

**Description**: Shows the history in graph representation of this git project.

### `stats` Get Git Statistics

```sh
git config --global alias.stats '!f() { 
  if [ -z "$1" ]; then 
    AUTHOR=$(git config --local user.name); 
    if [ -z "$AUTHOR" ]; then 
      AUTHOR=$(git config --global user.name); 
    fi; 
  else 
    AUTHOR="$1"; 
  fi; 
  REPO=$(basename $(git rev-parse --show-toplevel)); 
  NUM_COMMITS=$(git log --author="$AUTHOR" --pretty=oneline | wc -l | xargs)
  NUM_FILES_CHANGED=$(git log --author="$AUTHOR" --name-only --pretty=format: | sort | uniq | wc -l | xargs)
  FIRST_COMMIT=$(git log --author="$AUTHOR" --reverse --pretty=format:"%ad" --date=short | head -n 1)
  LAST_COMMIT=$(git log --author="$AUTHOR" --pretty=format:"%ad" --date=short | head -n 1)
  TOTAL_COMMITS=$(git rev-list --all --count)
  
  git log --author="$AUTHOR" --pretty=tformat: --numstat | 
  awk -v author="$AUTHOR" -v repo="$REPO" -v num_commits="$NUM_COMMITS" -v num_files_changed="$NUM_FILES_CHANGED" -v first_commit="$FIRST_COMMIT" -v last_commit="$LAST_COMMIT" -v total_commits="$TOTAL_COMMITS" "BEGIN { 
    white = \"\033[0;37m\"
    green = \"\033[0;32m\"
    red = \"\033[0;31m\"
    yellow = \"\033[1;33m\"
    reset = \"\033[0m\"
    border = \"|==================================================|\"
    header = \"|=*=*=*=*=*=*=*=*= Git Statistics =*=*=*=*=*=*=*=*=|\"
    
    print border
    print header
    print border
    printf \"| %-25s %s%-22s%s |\n\", \"Author:\", white, author, reset
    printf \"| %-25s %s%-22s%s |\n\", \"Repository:\", white, repo, reset
    printf \"| %-25s %s%-22s%s |\n\", \"Commits:\", white, num_commits, reset
    printf \"| %-25s %s%-22s%s |\n\", \"Files Changed:\", white, num_files_changed, reset
    printf \"| %-25s %s%-22s%s |\n\", \"First Commit:\", white, first_commit, reset
    printf \"| %-25s %s%-22s%s |\n\", \"Last Commit:\", white, last_commit, reset
    printf \"| %-25s %s%-22s%s |\n\", \"Total Commits in Repo:\", white, total_commits, reset
    print border
  } 
  { 
    add += \$1; 
    subs += \$2; 
    loc += \$1 - \$2 
  } 
  END { 
    printf \"| %-25s %s+ %-20d%s |\n\", \"Added Lines:\", green, add, reset
    printf \"| %-25s %s- %-20d%s |\n\", \"Removed Lines:\", red, subs, reset
    printf \"| %-25s %sΔ %-20d%s |\n\", \"Total Lines:\", yellow, loc, reset
    print \"|==================================================|\\n\"
  }" -; 
}; f'
```

**Description**: Get a short and sweet overview of the amount of lines you've added to the git project that you're currently in. Command can be used as `git stats` when you want to see your own stats, or `git stats "Name of Person"` to see it by name.

### `find-branch` Find branch by name

```sh
git config --global alias.find-branch '!f() { 
  branches=$(git branch --list | grep "$1"); 
  if [ -z "$branches" ]; then 
    echo "No results found"; 
  else 
    echo "$branches"; 
  fi; 
}; f'
```

**Description**: In longer running projects with a lot of different branches being worked on simultaneously, it's sometimes quicker to figure out the name of a specific branch than to go back to the project management tool of choice to find what name someone gave to it. If you know a part of the name, that should be enough.
