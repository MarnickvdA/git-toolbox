# git-toolbox

Collection of useful git commands and tricks. Always good to have them ready.

## Tips

### Enabling Rerere

`git config --global rerere.enabled true`

**Description**: Enable Reuse Recorded Resolution which is especially useful when working in a codebase with other collaborators. It will store how conflict resolution has been done for a specific conflict so the next time a rebase is done, these conflicts are automatically resolved. Legend says this is one of the most common problems why people hate rebasing. Skill issues, perhaps.


## Commands

### Squashing commits on branch

`git rebase -i HEAD~N`, where `N` is the amount of commits that need to be rebased.

**Description**: This command will open up your editor of choice, and this is where you should change all entries of `pick` to `squash` expect the first entry. 

> `TODO`
>
> Create shortcut to squash all commits until the place where the branch based of the parent branch.

### `oopsie` reverts the last pushed commit...

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

### `commitpush` Commit w/ message and push it!

`git config --local alias.commitpush '!f() { git commit -am $1; git push; }; f'`

### `new` Fast branch creation

`git config --global alias.new 'switch -c'`

Yes, I'm this lazy.

### `del` Fast branch deletion

`git config --global alias.del '!f() { git switch -; git branch -D $1; }; f'`

### Fast branch pruning

`TODO`

### `graph` Show Git Repository Graph

`git config --global alias.graph 'log --graph --oneline --decorate --branches --tags'`

**Description**: Shows the history in graph representation of this git project.

### `stats` Get Git Stats by Author Name

```
git config --global alias.stats '!f() { git log --author="$1" --pretty=tformat: --numstat | awk "{ add += \$1; subs += \$2; loc += \$1 - \$2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\n\", add, subs, loc }" -; }; f'
```

**Description**: Get a short and sweet overview of the amount of lines you've added to the git project that you're currently in. Command can be used as `git stats John Doe`, or any other name for that matter.


### `fb` Find branch by name

`git config --local alias.fb '!f() { branches=$(git branch --list | grep "$1"); if [ -z "$branches" ]; then echo "No results found"; else echo "$branches"; fi; }; f'`

**Description**: In longer running projects with a lot of different branches being worked on simultaneously, it's sometimes quicker to figure out the name of a specific branch than to go back to the project management tool of choice to find what name someone gave to it. If you know a part of the name, that should be enough.




