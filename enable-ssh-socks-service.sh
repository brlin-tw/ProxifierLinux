#!/usr/bin/env bash
# Enable SOCKS proxy service over SSH
#
# Copyright 2024 林博仁(Buo-ren, Lin) <Buo.Ren.Lin@gmail.com>
# SPDX-License-Identifier: CC-BY-SA-4.0

SOCKS_HOST="${SOCKS_HOST:-127.0.0.1}"
SOCKS_PORT="${SOCKS_PORT:-1080}"

SSH_USER="${SSH_USER:-"${USER:-user}"}"
SSH_HOST="${SSH_HOST:-192.168.49.1}"
SSH_PORT="${SSH_PORT:-2222}"

printf \
    'Info: Configuring the defensive interpreter behaviors...\n'
set_opts=(
    # Terminate script execution when an unhandled error occurs
    -o errexit
    -o errtrace

    # Terminate script execution when an unset parameter variable is
    # referenced
    -o nounset
)
if ! set "${set_opts[@]}"; then
    printf \
        'Error: Unable to configure the defensive interpreter behaviors.\n' \
        1>&2
    exit 1
fi

printf \
    'Info: Checking the existence of the required commands...\n'
required_commands=(
    ssh
)
flag_required_command_check_failed=false
for command in "${required_commands[@]}"; do
    if ! command -v "${command}" >/dev/null; then
        flag_required_command_check_failed=true
        printf \
            'Error: This program requires the "%s" command to be available in your command search PATHs.\n' \
            "${command}" \
            1>&2
    fi
done
if test "${flag_required_command_check_failed}" == true; then
    printf \
        'Error: Required command check failed, please check your installation.\n' \
        1>&2
    exit 1
fi

printf \
    'Info: Setting the ERR trap...\n'
trap_err(){
    printf \
        'Error: The program prematurely terminated due to an unhandled error.\n' \
        1>&2
    exit 99
}
if ! trap trap_err ERR; then
    printf \
        'Error: Unable to set the ERR trap.\n' \
        1>&2
    exit 1
fi

printf \
    'Info: Enabling SOCKS service over SSH...\n'
ssh_opts=(
    # Specify port of the SSH service
    -p "${SSH_PORT}"

    # Enable SOCKS forwwarding service
    -D "${SOCKS_HOST}:${SOCKS_PORT}"

    # Enable quiet mode to suppress unnecessary messages
    -q

    # Enable compression: Is this really needed?
    #-C

    # Do not execute remote command, only run the forwarding service
    -N

    # Go to background after authentication to avoid stucking the
    # terminal
    -f
)
# The parameter expansions is indeed should be expanded on the client
# side
# shellcheck disable=SC2029
if ! ssh "${ssh_opts[@]}" "${SSH_USER}@${SSH_HOST}"; then
    printf \
        'Error: Unable to enable SOCKS service over SSH.\n' \
        1>&2
    exit 2
fi

printf \
    'Info: Operation completed without errors.\n'
