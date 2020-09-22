#!/bin/sh
# 5.3.1 Ensure password creation requirements are configured
apt-get install libpam-pwquality
grep -q '^password.*requisite.*pam_pwquality\.so.*retry=[0-9]' /etc/pam.d/common-password &&
        sed -i 's/^password.*requisite.*pam_pwquality\.so.*retry=[0-9]/password        requisite        pam_pwquality.so retry=3/' /etc/pam.d/common-password ||
        echo 'password        requisite        pam_pwquality.so retry=3' >> /etc/pam.d/common-password

grep -q '^minlen' /etc/security/pwquality.conf && sed -i 's/^minlen.*/minlen = 14/' /etc/security/pwquality.conf || echo 'minlen = 14' >> /etc/security/pwquality.conf
grep -q '^dcredit' /etc/security/pwquality.conf && sed -i 's/^dcredit.*/dcredit = -1/' /etc/security/pwquality.conf || echo 'dcredit = -1' >> /etc/security/pwquality.conf
grep -q '^ucredit' /etc/security/pwquality.conf && sed -i 's/^ucredit.*/ucredit = -1/' /etc/security/pwquality.conf || echo 'ucredit = -1' >> /etc/security/pwquality.conf
grep -q '^ocredit' /etc/security/pwquality.conf && sed -i 's/^ocredit.*/ocredit = -1/' /etc/security/pwquality.conf || echo 'ocredit = -1' >> /etc/security/pwquality.conf
grep -q '^lcredit' /etc/security/pwquality.conf && sed -i 's/^lcredit.*/lcredit = -1/' /etc/security/pwquality.conf || echo 'lcredit = -1' >> /etc/security/pwquality.conf
