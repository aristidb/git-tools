#!/bin/bash

BACKUP_BRANCH=refs/heads/backup
BACKUP_MESSAGE=Backup
TMPDIR=$(mktemp -d /tmp/git-backup-XXXX)
export GIT_INDEX_FILE=$TMPDIR/index

LAST_COMMIT=$(git rev-parse --revs-only $BACKUP_BRANCH)
LAST_TREE=$(git rev-parse --revs-only $BACKUP_BRANCH^{tree})

echo 'Create index'
git add --verbose --all
echo 'Write index'
NEXT_TREE=$(git write-tree)

echo lc:$LAST_COMMIT lt:$LAST_TREE nt:$NEXT_TREE

if [ $LAST_TREE!=$NEXT_TREE ]
then
    if [ $LC!= ]
    then
        echo Write first commit
        CSHA=$(echo $BACKUP_MESSAGE | git commit-tree $NEXT_TREE)
    else
        echo Write commit
        CSHA=$(echo $BACKUP_MESSAGE | git commit-tree -p $LAST_COMMIT $NEXT_TREE)
    fi
    echo Update branch $BACKUP_BRANCH
    git update-ref $BACKUP_BRANCH $CSHA
fi

rm -rf $TMPDIR
