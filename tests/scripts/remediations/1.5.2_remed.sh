#!/bin/bash
printf "%s\n" "kernel.yama.ptrace_scope = 1" >> /etc/sysctl.d/60-kernel_sysctl.conf
sysctl -w kernel.yama.ptrace_scope=1
