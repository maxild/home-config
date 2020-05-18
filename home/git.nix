{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "${config.settings.git.username}";
    userEmail = "${config.settings.git.email}";
    # signing = {
    #   signByDefault = true;
    #   key = config.resources.gpg.publicKey.fingerprint;
    # };
    ignores = [
      "*.log"
      # Folder view configuration files (Finder OSX)
      ".DS_Store"
      "Desktop.ini"
      # Thumbnail cache files (OSX)
      "._*"
      "Thumbs.db"
      # Files that might appear on external disks
      ".Spotlight-V100"
      ".Trashes"
    ];
    # TODO: stdenv.isLinux || stdenv.isDarwin
    extraConfig = {
      apply = {
        # Detect whitespace errors when applying a patch
        whitespace = "fix";
      };
      core = {
        # TODO: Use custom `.gitignore` and `.gitattributes`
        #excludesfile = ~/.gitignore
        #attributesfile = ~/.gitattributes

        # Treat spaces before tabs and all kinds of trailing whitespace as an error
        # [default] trailing-space: looks for spaces at the end of a line
        # [default] space-before-tab: looks for spaces before tabs at the beginning of a line
        whitespace = "space-before-tab,-indent-with-non-tab,trailing-space";

        # Make `git rebase` safer on OS X
        # More info: <http://www.git-tower.com/blog/make-git-rebase-safe-on-osx/>
        trustctime = false;

        # Prevent showing files whose names contain non-ASCII symbols as unversioned.
        # http://michael-kuehnel.de/git/2014/11/21/git-mac-osx-and-german-umlaute.html
        precomposeunicode = false;

        # Make git log show UTF8 encoded characters properly (-R means Output "raw" control characters)
        pager = "LESSCHARSET=utf-8 less -R";
      };

      diff = {
        # Detect copies as well as renames
        renames = "copies";
        tool = "bcomp";
        # so you get clearer container diffs when referenced submodule commits changed
        submodule = "log";
      };
      difftool = {
        prompt = false;
      };
      "difftool \"bcomp\"" = {
        trustExitCode = true;
        # bcompare is not installed on darwin using nix
        cmd = if config.settings.host.isHeadless
              then ''"/usr/local/bin/bcomp"  "$LOCAL" "$REMOTE"''
              else ''\"${pkgs.bcompare}/bin/bcompare\" "$LOCAL" "$REMOTE"'';
      } // (if config.settings.host.isWsl then {
        # WSL 2 Ubuntu
        # We are changing the /mnt/c into C: via 'echo' and 'sed' commands (/mnt/c --> C:)
        # CMD does not support UNC paths as current directories, and therefore we cannot map
        # to P9-server UNC path

        path = ''"/mnt/c/Program Files/Beyond Compare 4/BCompare.exe"'';
        cmd = ''\"/mnt/c/Program Files/Beyond Compare 4/BCompare.exe\" -expandall \"`echo $LOCAL | sed 's_/mnt/c_C:_'`\" \"`echo $REMOTE | sed 's_/mnt/c_C:_'`\"'';
      } else {});

      merge = {
        # Include summaries of merged commits in newly created merge commit messages
        log = true;
        tool = "bcomp";
      };
      mergetool = {
        prompt = false;
      };
      "mergetool \"bcomp\"" = {
        trustExitCode = true;
        # bcompare is not installed on darwin using nix
        cmd = if config.settings.host.isHeadless
              then ''"/usr/local/bin/bcomp"  "$LOCAL" "$REMOTE" "$BASE" "$MERGED"''
              else ''\"${pkgs.bcompare}/bin/bcompare\" "$LOCAL" "$REMOTE" "$BASE" "$MERGED"'';
      } // (if config.settings.host.isWsl then {
        # WSL 2 Ubuntu
        # We are changing the /mnt/c into C: via 'echo' and 'sed' commands (/mnt/c --> C:)
        # CMD does not support UNC paths as current directories, and therefore we cannot map
        # to P9-server UNC path
        path = ''"/mnt/c/Program Files/Beyond Compare 4/BCompare.exe"'';
        cmd = ''\"/mnt/c/Program Files/Beyond Compare 4/BCompare.exe\" -expandall \"`echo $LOCAL | sed 's_/mnt/c_C:_'`\" \"`echo $REMOTE | sed 's_/mnt/c_C:_'`\" \"`echo $BASE | sed 's_/mnt/c_C:_'`\" \"`echo $MERGED | sed 's_/mnt/c_C:_'`\"'';
      } else {});

      color = {
        ui = true;
      };
      "color \"branch\"" = {
        current = "yellow reverse";
        local = "yellow";
        remote = "green";
      };
      "color \"diff\"" = {
        meta = "yellow bold";
        frag = "magenta bold";  # line info
        old = "red";            # deletions
        new = "green";          # additions
      };
      "color \"status\"" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan";
      };

      branch = {
        autosetupmerge = "always";
      };
      status = {
        # Display status of submodules when git status is invoked
        submoduleSummary = true;
      };
      push = {
  	    # push the current branch back to the branch whose changes are usually integrated
        # into the current branch (which is called @{upstream}) with the added safety to
        # refuse to push if the upstream branch’s name is different from the local one.
        # This mode only makes sense if you are pushing to the same repository you would normally
        # pull from (i.e. central workflow).
        default = "simple";
        # enable --follow-tags option by default. You may override this configuration at push time
        # by specifying --no-follow-tags.
        followTags = true;
      };
      fetch = {
        # so you are confident new referenced commits for known submodules get fetched with container updates
        recurseSubmodules = "on-demand";
      };
      help = {
        # Automatically correct and execute mistyped commands
        autocorrect = "1";
      };
      #  See https://help.github.com/articles/caching-your-github-password-in-git/
      credential = {
        helper = /**/ if pkgs.stdenv.isDarwin then "osxkeychain"
                 # gnome keyring not working, use this less safe method where pwd is saved in clear text
                 else if pkgs.stdenv.isLinux  then "store --file ~/.my-credentials"
                 else "cache --timeout=3600";
      };
    };
    aliases = {
      # One letter alias for our most frequent commands.
      a = "add";
      b = "branch";
      c = "commit";
      d = if config.settings.host.isWsl
          then "difftool -y --no-symlinks"
          else "difftool";
      f = "fetch";
      g = "grep";
      l = "log";
      m = "merge";
      o = "checkout";
      p = "pull";
      r = "remote";
      s = "status";
      w = "whatchanged";

      ### add ###

      # add all
      aa = "add --all";
      # add by patch - looks at each change, and asks if we want to put it in the repo.
      #ap = add --patch
      # add just the files that are updated.
      #au = add --update

      ### branch ###

      # delete branch
      bd="branch -d";
      # branch force delete
      bfd="branch -D";
      # branch and only list branches whose tips are reachable from the specified commit (HEAD if not specified).
      bm = "branch --merged";
      # branch and only list branches whose tips are not reachable from the specified commit (HEAD if not specified).
      bnm = "branch --no-merged";

      ### commit ###

      # commit - amend the tip of the current branch rather than creating a new commit.
      ca = "commit --amend";
      # commit with a message
      cm = "commit --message";

      ## diff ##

      # Show diff of last commit (or the given number of commits ago)
      dlc = ''"!f() { git difftool --cached HEAD~$1; }; f"'';
      # Show diff of a commit
      dc  = ''"!f() { git difftool "$1"^.."$1"; }; f"'';


      ### checkout ###

      # checkout - update the working tree to match a branch or paths. [same as "o" for "out"]
      co = "checkout";
      # Switch to a branch, creating it (possibly as a local tracking branch) if necessary
      go = ''"!f() { git checkout \"$1\" 2> /dev/null || git checkout -b \"$1\"; }; f"'';
      # Switch to a feature branch, creating it (possibly as a local tracking branch) if necessary
      gof = ''"!f() { \
        branch_name="$1"; \
        if [[ ! "$branch_name" =~ ^feature/.* ]]; then \
            branch_name="feature/''${branch_name}"; \
        fi; \
        git checkout \"''${branch_name}\" 2> /dev/null || git checkout -b \"''${branch_name}\"; \
      }; f"'';

      ### log ###

      # log like - we like this format that shows our key performance indicators, i.e. our useful summary.
      ll = "log --graph --topo-order --abbrev-commit --date=short --decorate --all --boundary --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset'";
      lol="log --graph --decorate --pretty=oneline --abbrev-commit";
      lola="log --graph --decorate --pretty=oneline --abbrev-commit --all";

      # List modified files helper
      ll-private-helper = "log --date=short --decorate --pretty=format:'%Cgreen%ad %Cred%h%Creset -%C(yellow)%d%Creset %s %Cblue[%cn]%Creset %Cblue%G?%Creset' --numstat";

      # Show modified files of a commit
      lc  = ''"!f() { git ll-private-helper "''${1-HEAD}"^.."''${1-HEAD}"; }; f"'';

      # Show modified files in last commit (or the given number of commits ago)
      llc  = ''"!f() { git ll-private-helper "HEAD~$1"^.."HEAD~$1" ; }; f"'';

      ## ls-files ##

      # ls-files - show information about files in the index and the working tree; like Unix "ls" command.
      ls = "ls-files";

      # list files that git has ignored.
      ls-ignored = "ls-files --others --i --exclude-standard";

      ### merge ###

      # merge but without autocommit, and with a commit even if the merge resolved as a fast-forward.
      me = "merge --no-commit --no-ff";

      # Merge branch into current HEAD, and with a (merge) commit even if the merge resolved as a fast-forward.
      mea = ''"!f() { git merge --no-ff --edit $1; }; f"'';

      # merge feature branch into dev branch (TODO: Maybe 1) fetch initially,
      # checking we are not behind, and 2) delete the remote feature branch,
      # if it exists on github/upstream)
      mefb = ''"!f() { \
          branch_name="$1"; \
          if [[ ! "$branch_name" =~ ^feature/.* ]]; then \
              branch_name="feature/''${branch_name}"; \
          fi; \
          git checkout dev && \
          git merge --no-ff --edit "''${branch_name}" && \
          git branch -d "''${branch_name}"; \
      }; f"'';

      # Merge GitHub pull request on top of the `master` branch
      mepr = ''"!f() { \
          if [ $(printf \"%s\" \"$1\" | grep '^[0-9]\\+$' > /dev/null; printf $?) -eq 0 ]; then \
              git fetch origin refs/pull/$1/head:pr/$1 && \
              git rebase master pr/$1 && \
              git checkout master && \
              git merge pr/$1 && \
              git branch -D pr/$1 && \
              git commit --amend -m \"$(git log -1 --pretty=%B)\n\nCloses #$1.\"; \
          fi \
      }; f"'';

      ### pull ###

      # pull if a merge can be resolved as a fast-forward, otherwise fail.
      pf = "pull --ff-only";

      #pr="pull --rebase";

      ### push ###

      #ppr="push --set-upstream origin";

      ### rebase ###

      # rebase - continue the rebasing process after resolving a conflict manually and updating the index with the resolution.
      rbc = "rebase --continue";

      # rebase - restart the rebasing process by skipping the current patch.
      rbs = "rebase --skip";

      # rbi - rebase interactive on our unpushed commits.
      #
      # Before we push our local changes, we may want to do some cleanup,
      # to improve our commit messages or squash related commits together.
      #
      # Let's say I've pushed two commits that are related to a new feature and
      # I have another where I made a spelling mistake in the commit message.
      # When I run "git rbi" I get dropped into my editor with this:
      #
      #     pick 7f06d36 foo
      #     pick ad544d0 goo
      #     pick de3083a hoo
      #
      # Let's say I want to squash the "foo" and "goo" commits together,
      # and also change "hoo" to say "whatever". To do these, I change "pick"
      # to say "s" for squash; this tells git to squash the two together;
      # I also edit "hoo". I make the file look like:
      #
      #     pick 7f06d36 foo
      #     s ad544d0 goo
      #     r de3083a whatever
      # This gives me two new commit messages to edit, which I update.
      # Now when I push the remote repo host receives two commits
      #
      #     3400455 - foo
      #     5dae0a0 - whatever
      #
      # NOTE: When you have a tracking branch set up, you can reference its
      #       upstream branch with the @{upstream} or @{u} shorthand.
      rbi = "rebase --interactive @{upstream}";

      # Interactive rebase with the given number of latest commits (i.e. history rewriting before push)
      reb = ''"!r() { git rebase --interactive HEAD~$1; }; r"'';

      # See https://blog.filippo.io/git-fixup-amending-an-older-commit/
      # This is a slightly modified version
      fixup = ''"!f() { TARGET=$(git rev-parse \"$1\"); git commit --fixup=$TARGET && GIT_EDITOR=true git rebase --interactive --autosquash $TARGET~; }; f"'';

      ### status ###

      # status with short format ignoring changes in submodules (can be either "untracked", "dirty" or "all").
      #   * Using "dirty" ignores all changes to the work tree of submodules (this was the behavior before 1.7.0)
      #      ss = status --short --ignore-submodules=dirty
      ss = "status --short";

      # status with short format and showing branch and tracking info.
      ssb = "status --short --branch";

      ### submodule ###

      # submodule - enables foreign repositories to be embedded within a dedicated subdirectory of the source tree.
      sm = "submodule";

      # submodule update
      smu = "submodule update";

      # submodule update with initialize (after cloning, collaborator need to init
      # and update the  .git/config to be aware of .gitmodules content)
      smui = "submodule update --init";

      # submodule update with initialize and recursive; this is useful to bring a submodule fully up to date.
      smuir = "submodule update --init --recursive";

      ### clone ###

      # Clone a git repository including all submodules
      cloner = "clone --recursive";

      ### pull repo with submodules  ###

      # fetch and prune, pull and rebase, then update submodules (git pull will fetch all submodules by default, but will not update submodules)
      spull = ''"!f() { git fetch --prune && git pull --rebase=preserve "$@" && git submodule sync --recursive && git submodule update --init --recursive; }; f"'';
      spush = "push --recurse-submodules=on-demand";

      ### clean ###

      # clean everything to be pristine
      cleanest = "clean -ffdx";

      #
      # Local branches
      #

      # A summary of all local branches with their tracking branch and status (ahead/behind)
      branches = ''"!f() { git fetch --all && git branch -vv; }; f"'';

      # Cleanup local branches (current=HEAD, dev and master cannot be deleted)
      # that have already been merged into the current branch (i.e. HEAD)
      # a.k.a. ‘delete merged branches’

      # Delete merged branches (dmb)
      dmb = ''"!f() { git branch --merged | grep -v '\\*\\|dev\\|develop\\|master' | xargs -n 1 git branch -d }; f"'';

      # Dry run of dmb
      dmbn = ''"!f() { git branch --merged | grep -v '\\*\\|dev\\|develop\\|master' | xargs -n 1 echo }; f"'';

      #  1) git branch --merged ${1-dev} lists all the branches that have been merged
      #  into the specified branch (or dev if none is specified).
      #  2) The grep command will list all merged branches that are not dev, master or the specified branch itself.
      #dm = "!f() { git branch --merged ${1-dev}$ | grep -v '${1-dev}$|dev|develop|master' | xargs -r git branch -d; }; f"
      #dmn = "!f() { git branch --merged ${1-dev}$ | grep -v '${1-dev}$|dev|develop|master' | xargs -r echo; }; f"

      #
      # Remote branches (refs/remotes/)
      #

      # show all remote branches
      rb = ''"!f() { \
          for branch in `git branch -r | grep -v HEAD`; \
          do echo -e `git show --format=\"%ci %cr %an\" $branch | head -n 1` $branch; \
          done | sort -r; \
      }; f"'';

      # show remote branches that have been merged into the current HEAD
      # (and decide if any should be deleted: git push origin --delete branch-name)
      rbm = ''"!f() { \
          for branch in `git branch -r --merged | grep -v HEAD`; \
          do echo -e `git show --format=\"%ci %cr %an\" $branch | head -n 1` $branch; \
          done | sort -r; \
      }; f"'';

      # show remote branches that have not been merged into the current HEAD
      rbnm = ''"!f() { \
          for branch in `git branch -r --no-merged | grep -v HEAD`; \
          do echo -e `git show --format=\"%ci %cr %an\" $branch | head -n 1` $branch; \
          done | sort -r; \
      }; f"'';

      # After each git pull or git fetch command Git creates references to remote branches
      # in local repository, but doesn’t clean up stale references.
      # Delete remote branches (prune all stale remote refs)
      drb = ''"!f() { git remote prune ''${1-origin}; }; f"'';

      #
      # Show tags, remotes, aliases, contributors
      #

      # Show verbose output about tags
      tags = "tag -l";

      # Show verbose output about remotes
      remotes = "remote -v";

      # List all aliases in config
      alias = ''"!f() { git config --get-regexp '^alias.'; }; f"'';

      # List all aliases in config (cutting out 'alias.' part such that sorting is possible)
      aliases = ''"!git config -l | grep '^alias.' | cut -c 7- | sort"'';

      # List contributors with number of commits
      contributors = "shortlog --summary --numbered";

      # Credit an author on the latest commit
      credit = ''"!f() { git commit --amend --author \"$1 <$2>\" -C HEAD; }; f"'';

      ### grep ###

      # Find text in any commit ever.
      grep-all = ''"!f() { git rev-list --all | xargs git grep \"$@\"; }; f"'';

      # Find text and group the output lines. Also aliased as `gg`.
      grep-group = "grep --break --heading --line-number";

      # grep with ack-like formatting
      ack = ''-c color.grep.linenumber=\"bold yellow\" \
              -c color.grep.filename=\"bold green\" \
              -c color.grep.match=\"reverse yellow\" \
              grep --break --heading --line-number'';

      # Find branches containing commit
      fb = ''"!f() { git branch -a --contains $1; }; f"'';

      # Find tags containing commit
      ft = ''"!f() { git describe --always --contains $1; }; f"'';

      # Find commits by source code
      fc = ''"!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short -S$1; }; f"'';

      # Find commits by commit message
      fm = ''"!f() { git log --pretty=format:'%C(yellow)%h  %Cblue%ad  %Creset%s%Cgreen  [%cn] %Cred%d' --decorate --date=short --grep=$1; }; f"'';

      ### misc ###

      latest="for-each-ref --sort=-taggerdate --format='%(refname:short)' --count=1";

      undo="git reset --soft HEAD^";
    };
  };
}
