#!/bin/bash

BACKUP_BRANCH=refs/heads/backup
export GIT_INDEX_FILE=$(mktemp /tmp/git-idx-XXXX)

LAST_COMMIT=$(git rev-parse $BACKUP_BRANCH)
LAST_TREE=$(git rev-parse $BACKUP_BRANCH^{tree})

git add --all
NEXT_TREE=$(git write-tree)

echo lc:$LAST_COMMIT lt:$LAST_TREE nt:$NEXT_TREE

#rm -f $GIT_INDEX_FILE
