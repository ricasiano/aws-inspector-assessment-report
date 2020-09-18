#!/bin/sh
# 5.4.1.4 Ensure inactive password lock is 30 days or less
if [ `useradd -D | grep INACTIVE | cut -d"=" -f2` -lt 30 ]; then
  echo "Default inactivity of password is lower than 30. Setting to 30"
  useradd -D -f 30
fi

# changing current settings per existing user that has a password
for  user in `egrep ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1`; do
  parsed_date=`chage --list root | grep -i "password inactive" | cut -d":" -f2 | sed 's/,//g' | xargs`
  if [ "$parsed_date" = "never" ]; then
    echo "Sets password inactivity days to 30 for $user"
    chage --inactive 30 $user
  else
    inactive_date=`date +%s -d "$parsed_date"`
    current_date=`date +%s`
    days_in_seconds=`expr $inactive_date - $current_date`
    days=`expr $days_in_seconds / 86400`
    if [ $days -gt 30 ]; then
      echo "Sets password inactivity days to 30 for $user"
      chage --inactive 30 $user
    fi
  fi
done
