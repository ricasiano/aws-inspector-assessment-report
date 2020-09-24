#!/bin/sh

# 4.1.1.2 Ensure system is disabled when audit logs are full

if [ `grep -c "^space_left_action" /etc/audit/auditd.conf` -eq 0 ]; then
  printf "\nspace_left_action = email" >> /etc/audit/auditd.conf
else
  sed -Ei "s/^(space_left_action).*=.*/\1 = email/g" /etc/audit/auditd.conf
fi

if [ `grep -c "^action_mail_acct" /etc/audit/auditd.conf` -eq 0 ]; then
  printf "\naction_mail_acct = root" >> /etc/audit/auditd.conf
else
  sed -Ei "s/^(action_mail_acct).*=.*/\1 = root/g" /etc/audit/auditd.conf
fi

if [ `grep -c "^admin_space_left_action" /etc/audit/auditd.conf` -eq 0 ]; then
  printf "\nadmin_space_left_action = halt" >> /etc/audit/auditd.conf
else
  sed -Ei "s/^(admin_space_left_action).*=.*/\1 = halt/g" /etc/audit/auditd.conf
fi

service auditd restart
