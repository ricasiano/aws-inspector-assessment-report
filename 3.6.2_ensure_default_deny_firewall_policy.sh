#!/bin/sh
for rule in `iptables -L | grep -iP '^chain (input|output|forward) \(policy (?!DROP).*\)$' | cut -d" " -f2`; do
  iptables -P $rule DROP
done
