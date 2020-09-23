#!/bin/bash
timeout_entry="
TMOUT=900
readonly TMOUT
export TMOUT"
if [ `grep -c "TMOUT=" /etc/profile` -ne 0 ]; then
  echo "timeout policy already exists."
else
  echo "Creating timeout policy entry..."
  echo "$timeout_entry" >> /etc/profile
  echo "done."
fi
[ `grep -c "TMOUT=" /etc/bash.bashrc` -eq 0 ] && echo "$timeout_entry" >> /etc/bash.bashrc
for shell_file in `ls /etc/profile.d/*.sh`; do
  [ `grep -c "TMOUT=" $shell_file` -eq 0 ] && echo "$timeout_entry" >> "$shell_file"
done
