#!/bin/bash

echo "5.4.5 Ensure default user shell timeout is 900 seconds or less"
# https://www.cyberciti.biz/faq/linux-tmout-shell-autologout-variable/
# we'll be using /etc/profile to propagate the time-out policy globally
if [ `grep -c "TMOUT=" /etc/profile` -ne 0 ]; then
  echo "timeout policy already exists."
else
  echo "Creating timeout policy entry..."
  echo "TMOUT=300
readonly TMOUT
export TMOUT" >> /etc/profile
  echo "done."
fi
