echo "Installing Git Aliases..."

git config --global rerere.enabled true

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

git config --global alias.new 'switch -c'

git config --global alias.del '!f() { 
  git switch -; 
  git branch -D $1; 
}; f'

git config --global alias.prune-branches '!f() { 
  git switch main && git fetch -p && 
  for branch in $(git branch -vv | grep ": gone]" | awk '"'"'{print $1}'"'"'); do 
    echo "Deleting branch $branch"; 
    git branch -d "$branch"; 
  done; 
}; f'

git config --global alias.graph 'log --graph --oneline --decorate --branches --tags'

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

git config --global alias.find-branch '!f() { 
  branches=$(git branch --list | grep "$1"); 
  if [ -z "$branches" ]; then 
    echo "No results found"; 
  else 
    echo "$branches"; 
  fi; 
}; f'

echo "Installing Git Aliases... Done!"
