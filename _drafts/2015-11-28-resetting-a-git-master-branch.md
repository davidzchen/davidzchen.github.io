---
layout: post
title: "Resetting a Git Master Branch"
date: 2015-11-28 22:48:24
categories:
  - tech
---

I took a look at your fork and the revision history for this PR. It looks like your master branch diverged from the azkaban/azkaban master a while ago and the commits for this PR are interleaved with more recent commits from upstream.

I actually tried cloning your fork of Azkaban, adding azkaban/azkaban as upstream, and doing `git rebase -i upstream/master`. Given the number of merge conflicts you would get compared to the size of your patch, I think it would be much simpler if you simply apply the net diff for this PR on top of a clean master branch that is identical to the upstream master.

Here is how you can do this:

1. In your repository, assuming you have azkaban/azkaban added as `upstream`, first sync your upstream:

        git fetch upstream

2. Create a new branch; let's call it `clean-master`:

        git checkout -b clean-master

3. Reset this branch to make it identical to `upstream/master`:

        git reset --hard upstream/master

4. Download the diff for this PR:

        wget https://github.com/azkaban/azkaban/pull/517.diff

5. Apply the diff:

        git apply 517.diff

6. The diff for your PR has now been applied on top of the `clean-master` branch, which is identical to upstream/master, but is not committed. Because you added `azkaban-execserver/src/main/resources/execute-as-user.c` as a new file, you would need to `git add` it. Now, remove the diff file, add `execute-as-user.c`, and commit:

        rm 517.diff
        git add azkaban-execserver/src/main/resources/execute-as-user.c
        git commit -am "<write your commit message here>"

7. Now, you can make your `master` branch identical to `clean-master` and then do a force-push to push your squashed patch to this Pull Request:

        git checkout master
        git reset --hard clean-master
        git push origin master -f

Once you have done this:

* This Pull Request will only contain one commit for your changes on top of master.
* Your master branch will be identical to the upstream master with the addition of your patch.

**Until this PR is merged**, if there are new commits that go into master before your commit, I would recommend rebasing so that your patch will come after those new commits:

```
git fetch upstream
git rebase -i upstream/master
```

After your patch is merged, sync your master branch with upstream using:

```
git fetch upstream
git merge upstream/master
```

After your patch is merged, I would recommend doing development in feature branches in your fork and keeping your master branch identical to upstream/master at all times, and when new changes land in master, rebase your feature branch on top of master. To illustrate:

```
git checkout -b new-feature
# Do some work.
# Some new commits land in master.
# Fetch upstream and sync master with upstream:
git checkout master
git fetch upstream
git merge upstream/master
# Rebase your feature branch on top of master:
git checkout new-feature
git rebase master
# If there are any merge conflicts, resolve the merge conflicts and then run
# git rebase --continue until the rebase is successful.
```

This way, your master branch will always be identical to upstream, and your commits are always on top of master and not interleaved with older commits. It is good to rebase often, whenever new commits land in master. This will greatly reduce the number of painful merge conflicts and will allow you to work on more than one change by using different feature branches.

The only caveat is that if you want to push your feature branch to your remote branch (such as if you want to continue working on a different machine), you would need to do a force push after you do a rebase:

```
git push origin new-feature -f
```

I think force-pushes for feature branches in this case are fine, but force pushes for master branches should be avoided whenever possible. :)

Anyway, sorry for the hassle. I think we should try to rebase and squash commits before merging pull requests. This way, we would reduce the likelihood of particularly nasty merge conflicts, keep the revision history cleaner, and make it easier to track down why a certain line of code is changed. This is also closer to what Apache projects do.
