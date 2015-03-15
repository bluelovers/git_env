#!/bin/sh
#
# Author: Gerhard Gappmeier, ascolab GmbH
# This script is based on the update.sample in git/contrib/hooks.
# You are free to use this script for whatever you want.
#
# To enable this hook, rename this file to "update".
#

# --- Command line
refname="$1"
oldrev="$2"
newrev="$3"
#echo "COMMANDLINE: $*"

# --- Safety check
if [ -z "$GIT_DIR" ]; then
	echo "Don't run this script from the command line." >&2
	echo " (if you want, you could supply GIT_DIR then run" >&2
	echo "  $0 <ref> <oldrev> <newrev>)" >&2
	exit 1
fi

if [ -z "$refname" -o -z "$oldrev" -o -z "$newrev" ]; then
	echo "Usage: $0 <ref> <oldrev> <newrev>" >&2
	exit 1
fi

BINARAY_EXT="pdb dll exe png gif jpg"

# returns 1 if the given filename is a binary file
function IsBinary() 
{
    result=0
    for ext in $BINARAY_EXT; do
        if [ "$ext" = "${1#*.}" ]; then
            result=1
            break
        fi
    done

    return $result
}

# make temp paths
tmp=$(mktemp /tmp/git.update.XXXXXX)
log=$(mktemp /tmp/git.update.log.XXXXXX)    
tree=$(mktemp /tmp/git.diff-tree.XXXXXX)
ret=0

git diff-tree -r "$oldrev" "$newrev" > $tree
#echo
#echo diff-tree:
#cat $tree

# read $tree using the file descriptors
exec 3<&0
exec 0<$tree
while read old_mode new_mode old_sha1 new_sha1 status name
do
    # debug output
    #echo "old_mode=$old_mode new_mode=$new_mode old_sha1=$old_sha1 new_sha1=$new_sha1 status=$status name=$name"
    # skip lines showing parent commit
    test -z "$new_sha1" && continue
    # skip deletions
    [ "$new_sha1" = "0000000000000000000000000000000000000000" ] && continue
   
    # don't do a CRLF check for binary files
    IsBinary $tmp
    if [ $? -eq 1 ]; then
        continue # skip binary files
    fi
    
    # check for CRLF
    git cat-file blob $new_sha1 > $tmp
    RESULT=`grep -Pl '\r\n' $tmp`
    echo $RESULT
    if [ "$RESULT" = "$tmp" ]; then
        echo "###################################################################################################"
        echo "# '$name' contains CRLF! Dear Windows developer, please activate the GIT core.autocrlf feature,"
        echo "# or change the line endings to LF before trying to push."
        echo "# Use 'git config core.autocrlf true' to activate CRLF conversion."
        echo "# OR use 'git reset HEAD~1' to undo your last commit and fix the line endings."
        echo "###################################################################################################"
        ret=1
    fi
done
exec 0<&3
# --- Finished
exit $ret