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
    'Info: Configuring the convenience variables...\n'
if test -v BASH_SOURCE; then
    # Convenience variables may not need to be referenced
    # shellcheck disable=SC2034
    {
        printf \
            'Info: Determining the absolute path of the program...\n'
        if ! script="$(
            realpath \
                --strip \
                "${BASH_SOURCE[0]}"
            )"; then
            printf \
                'Error: Unable to determine the absolute path of the program.\n' \
                1>&2
            exit 1
        fi
        script_dir="${script%/*}"
        script_filename="${script##*/}"
        script_name="${script_filename%%.*}"
    }
fi
# Convenience variables may not need to be referenced
# shellcheck disable=SC2034
{
    script_basecommand="${0}"
    script_args=("${@}")
}

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

operation_mode=enable

if test "${#}" -ne 0; then
    printf \
        'Info: Processing the command-line arguments...\n'
    while test "${#}" -ne 0; do
        case "${1}" in
            --help|-h)
                printf \
                    'Usage: %s [--help] [--disable]\n' \
                    "${0}"
                exit 0
            ;;
            --disable|-d)
                operation_mode=disable
                shift
            ;;
            *)
                printf \
                    'Error: Unsupported command-line option "%s".\n' \
                    "${1}" \
                    1>&2
                exit 1
            ;;
        esac
    done
fi

ssh_control_socket="${script_name}.sshd.socket"
case "${operation_mode}" in
    enable)
        printf \
            'Info: Enabling SOCKS service over SSH...\n'
        ssh_opts=(
            # Specify port of the SSH service
            -p "${SSH_PORT}"

            # Enable SOCKS forwwarding service
            -D "${SOCKS_HOST}:${SOCKS_PORT}"

            # Enable compression: Is this really needed?
            #-C

            # Do not execute remote command, only run the forwarding service
            -N

            # Go to background after authentication to avoid stucking the
            # terminal
            -f

            # Setup control socket to support disabling the SOCKS service
            -S "${ssh_control_socket}"
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
    ;;
    disable)
        printf \
            'Info: Disabling the SSH SOCKS service...\n'
        if ! test -e "${ssh_control_socket}"; then
            printf \
                'Error: SSH control socket file not found.\n' \
                1>&2
            exit 2
        fi

        ssh_opts=(
            # Specify port of the SSH service
            -p "${SSH_PORT}"

            # Setup control socket to support disabling the SOCKS service
            -S "${ssh_control_socket}"

            # Signal the service to shutdown
            -O exit
        )
        # The parameter expansions is indeed should be expanded on the client
        # side
        # shellcheck disable=SC2029
        if ! ssh "${ssh_opts[@]}" "${SSH_USER}@${SSH_HOST}"; then
            printf \
                'Error: Unable to disable the SSH SOCKS service.\n' \
                1>&2
            exit 2
        fi
    ;;
    *)
        printf \
            'FATAL: Unsupported operation_mode "%s".\n' \
            "${operation_mode}" \
            1>&2
        exit 99
    ;;
esac
printf \
    'Info: Operation completed without errors.\n'
