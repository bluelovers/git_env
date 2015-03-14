# do whatever the fuck you want with it license

# set 'assume unchanged' for files in list, replicates tortoise svn 'ignore on commit' feature
# source ~/.git-ignoreoncommit.sh in your profile
# https://github.com/falsefalse

function git-ioc {
  VER="0.2"
  ignorefile=".gitignore-oncommit"

  if [ -f $ignorefile ]; then
    files=$(cat $ignorefile)
  else
    files=""
    case "$1" in
      init)
        echo "Initializing git-ignore-on-commit..."
        # list changed files
        changed=$(git st -s --porcelain | awk '{print $2}')

        touch $ignorefile
        echo ".gitignore" >> $ignorefile

        # add currently changed files to ignore list
        for file in $changed; do
          echo ${file} >> $ignorefile
          echo "Added $file"
        done

        echo "Initialized, ignoring files..."
        git-ioc on
        return 0
      ;;
    esac
  fi

  case "$1" in 
    on)
      if [ ! -f $ignorefile ]; then
        echo "Not initialized. Try git-ioc init"
        return
      fi
      echo $ignorefile >> .gitignore
      for file in $files; do
          git update-index --assume-unchanged ${file}
          echo "Ignored ${file}"
      done
    ;;
    off)
      if [ ! -f $ignorefile ]; then
        echo "Not initialized. Try git-ioc init"
        return
      fi
      # TODO: grab file list from git ls-files -v
      for file in $files; do
          git update-index --no-assume-unchanged ${file}
          echo "Track ${file}"
      done
      git co .gitignore
    ;;
    remove)
      if [ ! -f $ignorefile ]; then
        echo "Not initialized. Try git-ioc init"
        return
      fi
      git-ioc off
      git co .gitignore && rm $ignorefile
      echo "Checked out .gitignore, removed $ignorefile"
      git st -s
    ;;
    # show list of 'assumed unchanged' files
    st)
      # fucking cygwin, [a-z] include uppercase letters as well, fuck me!
      # so I explicitely check for all known uppercase statuses, that sucks but works
      echo "# ignored by git"
      git ls-files -v | grep ^[^HSMRCK\?]
      echo "# $ignorefile"
      for file in $files; do
          echo $file
      done
    ;;
    help)
      echo "Makes git assume that certain changed files are unchanged."
      echo "More info git help update-index"
      echo -e
      echo "Usage: git-ioc <command>"
      echo -e
      echo "where <command> is one of:"
      echo "  init      recognize, save and ignore files that are currently changed in repo"
      echo "  st        show status of ignored files"
      echo "  remove    restore repo back to initial state"
      echo "  on        ignore files"
      echo "  off       track files back, reverts 'on'"
      echo -e
      echo "  help      show this help"
      echo "  version   print version and exit"
      echo -e
    ;;
    version)
      echo $VER
    ;;
    *)
      git-ioc help
    ;;
  esac
}

# autocomplete
# as described here http://www.debian-administration.org/article/An_introduction_to_bash_completion_part_2
_git-ioc() 
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts="init st remove on off help version"

    if [[ ${cur} == * ]] ; then
        COMPREPLY=( $(compgen -W "${opts}" ${cur}) )
        return 0
    fi
}
complete -F _git-ioc git-ioc