#!/usr/bin/env bash
{
    # Unmask the ufw service if it is masked
    systemctl unmask ufw.service
    echo "- Unmasked ufw.service."

    # Enable and start the ufw service
    systemctl --now enable ufw.service
    echo "- Enabled and started ufw.service."

    # Enable ufw firewall
    ufw enable
    echo "- Enabled ufw firewall."
}