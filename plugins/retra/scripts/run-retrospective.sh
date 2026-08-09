#!/bin/sh

set -u

MINIMUM_PYTHON="3.9"
PLUGIN_SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
RETROSPECTIVE_SCRIPT="$PLUGIN_SCRIPT_DIR/retrospective.py"

python_is_compatible() {
    "$@" -c 'import sqlite3, sys, zoneinfo; raise SystemExit(0 if sys.version_info >= (3, 9) else 1)' >/dev/null 2>&1
}

find_python() {
    if [ "${RETROSPECTIVE_FORCE_PYTHON_MISSING:-0}" = "1" ]; then
        return 1
    fi
    if [ -n "${RETROSPECTIVE_PYTHON:-}" ] && python_is_compatible "$RETROSPECTIVE_PYTHON"; then
        PYTHON_COMMAND="$RETROSPECTIVE_PYTHON"
        return 0
    fi
    for candidate in python3 python; do
        if command -v "$candidate" >/dev/null 2>&1 && python_is_compatible "$candidate"; then
            PYTHON_COMMAND="$candidate"
            return 0
        fi
    done
    # Prefer a compatible runtime already bundled with Codex before proposing
    # any system-level installation. The glob is intentionally best-effort.
    if [ -n "${HOME:-}" ]; then
        for candidate in \
            "$HOME"/.cache/codex-runtimes/*/dependencies/python/bin/python3 \
            "$HOME"/.codex/runtimes/*/dependencies/python/bin/python3; do
            if [ -x "$candidate" ] && python_is_compatible "$candidate"; then
                PYTHON_COMMAND="$candidate"
                return 0
            fi
        done
    fi
    return 1
}

platform_name() {
    case "$(uname -s 2>/dev/null || true)" in
        Darwin) printf '%s' "macOS" ;;
        Linux) printf '%s' "Linux" ;;
        *) printf '%s' "POSIX" ;;
    esac
}

recommended_installer() {
    if [ "$(platform_name)" = "macOS" ]; then
        if command -v brew >/dev/null 2>&1; then
            printf '%s' "brew install python@3.12"
        else
            printf '%s' "Install Homebrew, then run: brew install python@3.12"
        fi
        return
    fi
    if command -v apt-get >/dev/null 2>&1; then
        printf '%s' "sudo apt-get update && sudo apt-get install -y python3"
    elif command -v dnf >/dev/null 2>&1; then
        printf '%s' "sudo dnf install -y python3"
    elif command -v yum >/dev/null 2>&1; then
        printf '%s' "sudo yum install -y python3"
    elif command -v pacman >/dev/null 2>&1; then
        printf '%s' "sudo pacman -S --needed python"
    elif command -v zypper >/dev/null 2>&1; then
        printf '%s' "sudo zypper install -y python3"
    else
        printf '%s' "Install Python 3.9 or newer with sqlite3 and zoneinfo"
    fi
}

print_doctor() {
    if find_python; then
        version=$($PYTHON_COMMAND -c 'import platform; print(platform.python_version())')
        path=$(command -v "$PYTHON_COMMAND" 2>/dev/null || printf '%s' "$PYTHON_COMMAND")
        printf '{"ok":true,"platform":"%s","minimum_python":"%s","python":"%s","version":"%s","install_required":false}\n' \
            "$(platform_name)" "$MINIMUM_PYTHON" "$path" "$version"
    else
        printf '{"ok":false,"platform":"%s","minimum_python":"%s","python":null,"install_required":true,"recommended_command":"%s"}\n' \
            "$(platform_name)" "$MINIMUM_PYTHON" "$(recommended_installer)"
    fi
}

install_runtime() {
    if find_python; then
        print_doctor
        return 0
    fi
    if [ "$(platform_name)" = "macOS" ]; then
        if ! command -v brew >/dev/null 2>&1; then
            printf '%s\n' "Retrospective cannot install Python automatically because Homebrew is unavailable." >&2
            printf '%s\n' "Install Homebrew from https://brew.sh, then rerun onboarding." >&2
            return 2
        fi
        brew install python@3.12
    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y python3
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y python3
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y python3
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed python
    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper install -y python3
    else
        printf '%s\n' "No supported package manager was found. Install Python 3.9 or newer manually." >&2
        return 2
    fi
    if ! find_python; then
        printf '%s\n' "Python installation finished, but a compatible interpreter is not yet available in PATH." >&2
        return 2
    fi
    print_doctor
}

command_name=${1:-}
if [ "$command_name" = "doctor" ]; then
    print_doctor
    exit 0
fi
if [ "$command_name" = "install-runtime" ]; then
    install_runtime
    exit $?
fi
if ! find_python; then
    # Hooks must remain non-blocking until onboarding installs the runtime.
    exit 0
fi

exec "$PYTHON_COMMAND" "$RETROSPECTIVE_SCRIPT" "$@"
