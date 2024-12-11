#!/usr/bin/env bash
{
    # Backup /etc/shells before modifying it
    cp /etc/shells /etc/shells.bak

    # Remove lines containing 'nologin' from /etc/shells
    sed -i '/\/nologin\b/d' /etc/shells

    echo "Lines containing 'nologin' have been removed from /etc/shells."
}