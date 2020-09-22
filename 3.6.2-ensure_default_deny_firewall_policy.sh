#!/bin/sh
# 3.6.2 Ensure default deny firewall policy
for rule in `iptables -L | grep -iP '^chain (input|output|forward) \(policy (?!DROP).*\)$' | cut -d" " -f2`; do
  iptables -P $rule DROP
done
