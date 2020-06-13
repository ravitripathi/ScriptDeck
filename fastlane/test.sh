#!/bin/sh

# Credits: http://stackoverflow.com/a/750191

git filter-branch -f --env-filter "
    GIT_AUTHOR_NAME='Ravi Tripathi'
    GIT_AUTHOR_EMAIL='ravitripathi1996@gmail.com'
    GIT_COMMITTER_NAME='Ravi Tripathi'
    GIT_COMMITTER_EMAIL='ravitripathi1996@gmail.com'
  " HEAD
