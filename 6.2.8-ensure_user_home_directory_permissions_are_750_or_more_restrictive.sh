#!/bin/bash
# 6.2.8 Ensure users' home directories permissions are 750 or more restrictive
# https://secscan.acron.pl/centos7/6/2/8
#    loop through each entry in /etc/passwd
#    set colon(:) as the field separator
#    exclude lines with root, halt, sync, shutdown, -v flag inverts the result
#    exclude accounts with no shell logins, these are usually system accounts
#    get the home directory
for dir in `cat /etc/passwd | egrep -v '(root|halt|sync|shutdown)' | awk -F: '($7 != "/usr/sbin/nologin") { print $6 }'`; do
  #  extract the directory permission of the home directory for this user
  #  get the first column, which contains the binary representation of the directory permission
  #  set space( ) as the separator
  dirperm=`ls -ld $dir | cut -f1 -d" "`
  # column position in cut is +1 as first column contains the directory indicator
  # i.e. drwxr-xr-x
  # tests rwxr-xrwx permission
  if [ `echo $dirperm | cut -c6 ` != "-" ]; then
    echo "Group Write permission set on directory $dir. Removing permission."
    # remove group write permission
    chmod g-w $dir
  fi
  # tests rwxrwx-wx permission
  if [ `echo $dirperm | cut -c8 ` != "-" ]; then
    echo "Other Read permission set on directory $dir. Removing permission"
    # remove world read permission
    chmod o-r $dir
  fi
  # tests rwxrwxr-x permission
   if [ `echo $dirperm | cut -c9 ` != "-" ]; then
     echo "Other Write permission set on directory $dir. Removing permission"
   # remove world write permission
   chmod o-w $dir
   fi
   # tests rwxrwxrw- permission
   if [ `echo $dirperm | cut -c10 ` != "-" ]; then
     echo "Other Execute permission set on directory $dir. Removing permission"
     # remove world execute permission
     chmod o-x $dir
   fi
done
