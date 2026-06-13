REPO := justfile_directory()
FORCE := "0"
DRY := "0"
YES  := "0"

SERVICES := "iwd dbus bluetoothd"

HDR := '\033[1;36m'
OK  := '\033[0;32m'
DRF := '\033[0;33m'
ERR := '\033[0;31m'
DIM := '\033[2m'
RST := '\033[0m'
B   := '\033[1m'

[private]
default:
    @just --list

[private]
_deploy src dest:
    #!/bin/sh
    short=$(echo "{{ dest }}" | sed "s|^$HOME|~|")
    if [ "{{ FORCE }}" = "0" ] && [ -e "{{ dest }}" ]; then
        printf "    {{ OK }}skip    {{ DIM }}%s{{ RST }}\n" "$short"
        exit 0
    fi
    if [ "{{ DRY }}" = "1" ]; then
        printf "    {{ DRF }}dry     {{ DIM }}%s{{ RST }}\n" "$short"
        exit 0
    fi
    mkdir -p "$(dirname "{{ dest }}")"
    [ -e "{{ dest }}" ] && rm -rf "{{ dest }}"
    cp -rf "{{ src }}" "{{ dest }}"
    printf "    {{ OK }}deploy  {{ B }}%s{{ RST }}\n" "$short"

# add a deployed file to the repo for tracking
add file:
    #!/bin/sh
    target=$(echo "{{ file }}" | sed "s|^~|$HOME|")
    [ -e "$target" ] || { printf "    {{ ERR }}error{{ RST }}  not found: %s\n" "$target" >&2; exit 1; }
    case "$target" in
        "$HOME/.config/"*)
            rel=${target#"$HOME/.config/"}
            repo="{{ REPO }}/home/config/$rel"
            label="~/.config/$rel"
            ;;
        "$HOME/"*)
            rel=${target#"$HOME/"}
            repo="{{ REPO }}/home/$rel"
            label="~/$rel"
            ;;
        "/etc/"*)
            rel=${target#"/etc/"}
            repo="{{ REPO }}/etc/$rel"
            label="/etc/$rel"
            ;;
        *)
            printf "    {{ ERR }}error{{ RST }}  unsupported path (must start with ~/, ~/.config/, or /etc/)\n" >&2
            exit 1
            ;;
    esac
    mkdir -p "$(dirname "$repo")"
    case "$target" in
        /etc/*) sudo cp -rf "$target" "$repo" ;;
        *) cp -rf "$target" "$repo" ;;
    esac
    printf "    {{ OK }}added   {{ B }}%s{{ RST }}\n" "$label"

# deploy user configs (~/.config/* and ~/*)
user:
    #!/bin/sh
    printf "\n  {{ HDR }}user{{ RST }}  {{ DIM }}~/.config{{ RST }}\n"
    for file in $(find "{{ REPO }}/home/config" -type f 2>/dev/null | sed "s|{{ REPO }}/home/config/||" | sort); do
        just FORCE={{ FORCE }} _deploy "{{ REPO }}/home/config/$file" "$HOME/.config/$file"
    done
    home_files=$(find "{{ REPO }}/home" -type f -not -path "{{ REPO }}/home/config/*" -not -path "{{ REPO }}/home/s6/*" 2>/dev/null | sed "s|{{ REPO }}/home/||" | sort)
    if [ -n "$home_files" ]; then
        printf "\n  {{ HDR }}user{{ RST }}  {{ DIM }}~{{ RST }}\n"
        for file in $home_files; do
            just FORCE={{ FORCE }} _deploy "{{ REPO }}/home/$file" "$HOME/$file"
        done
    fi

# deploy system configs (/etc/*)
system:
    #!/bin/sh
    printf "\n  {{ HDR }}system{{ RST }}  {{ DIM }}/etc{{ RST }}\n"
    for file in $(find "{{ REPO }}/etc" -type f -not -path "{{ REPO }}/etc/s6/*" 2>/dev/null | sed "s|{{ REPO }}/etc/||" | sort); do
        dest="/etc/$file"
        if [ "{{ FORCE }}" = "0" ] && [ -e "$dest" ]; then
            printf "    {{ OK }}skip    {{ DIM }}/etc/%s{{ RST }}\n" "$file"
            continue
        fi
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}/etc/%s{{ RST }}\n" "$file"
            continue
        fi
        sudo mkdir -p "$(dirname "$dest")"
        [ -e "$dest" ] && sudo rm -rf "$dest"
        sudo cp -rf "{{ REPO }}/etc/$file" "$dest"
        printf "    {{ OK }}deploy  {{ B }}/etc/%s{{ RST }}\n" "$file"
    done
    s6_changed=0
    for item in adminsv config; do
        src="{{ REPO }}/etc/s6/$item"
        dest="/etc/s6/$item"
        [ -d "$src" ] && [ -n "$(ls -A "$src" 2>/dev/null)" ] || continue
        if [ "{{ FORCE }}" = "0" ] && [ -d "$dest" ] && diff -rq "$src" "$dest" >/dev/null 2>&1; then
            printf "    {{ OK }}skip    {{ DIM }}/etc/s6/%s{{ RST }}\n" "$item"
            continue
        fi
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}/etc/s6/%s{{ RST }}\n" "$item"
            continue
        fi
        sudo cp -rf "$src"/* "$dest"/
        sudo find "$dest" -type f \( -name run -o -name up -o -name down \) -exec chmod 755 {} +
        printf "    {{ OK }}deploy  {{ B }}/etc/s6/%s{{ RST }}\n" "$item"
        s6_changed=1
    done
    if [ "$s6_changed" = "1" ] && [ "{{ DRY }}" != "1" ]; then
        sudo s6 repository sync >/dev/null 2>&1 || true
        sudo s6 set commit >/dev/null 2>&1 || true
        sudo s6 live install >/dev/null 2>&1 || true
        printf "    {{ OK }}reload  {{ DIM }}s6 database{{ RST }}\n"
    fi

# deploy user services (~/.local/share/s6/*)
user-services:
    #!/bin/sh
    printf "\n  {{ HDR }}user-services{{ RST }}  {{ DIM }}~/.local/share/s6{{ RST }}\n"
    dest="$HOME/.local/share/s6"
    mkdir -p "$dest/rc" "$dest/sv"
    for name in $(ls -1 "{{ REPO }}/home/s6/sv/" 2>/dev/null | grep -v '^default$'); do
        src="{{ REPO }}/home/s6/sv/$name"
        target="$dest/sv/$name"
        if [ "{{ FORCE }}" = "0" ] && [ -d "$target" ] && diff -rq "$src" "$target" >/dev/null 2>&1; then
            printf "    {{ OK }}skip    {{ DIM }}%s{{ RST }}\n" "$name"
            continue
        fi
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}%s{{ RST }}\n" "$name"
            continue
        fi
        rm -rf "$target"
        cp -rf "$src" "$target"
        chmod +x "$target/run" 2>/dev/null || true
        printf "    {{ OK }}deploy  {{ B }}%s{{ RST }}\n" "$name"
    done
    src="{{ REPO }}/home/s6/sv/default"
    target="$dest/sv/default"
    rm -rf "$target"
    cp -rf "$src" "$target"
    if [ "{{ DRY }}" != "1" ]; then
        s6-db-reload -u >/dev/null 2>&1 || true
    fi
    printf "    {{ OK }}reload  {{ DIM }}database{{ RST }}\n"
    # Deploy start-session script
    if [ -f "{{ REPO }}/home/s6/start-session" ]; then
        cp -rf "{{ REPO }}/home/s6/start-session" "$dest/start-session"
        chmod +x "$dest/start-session"
        printf "    {{ OK }}deploy  {{ B }}start-session{{ RST }}\n"
    fi
    if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -d "${XDG_RUNTIME_DIR}/s6-rc" ]; then
        if [ "{{ DRY }}" = "1" ]; then
            for name in $(ls -1 "{{ REPO }}/home/s6/sv/" 2>/dev/null | grep -v '^default$'); do
                printf "    {{ DRF }}start   {{ DIM }}%s{{ RST }}\n" "$name"
            done
        else
            s6-rc -l "${XDG_RUNTIME_DIR}/s6-rc" -up change default 2>/dev/null || true
            for name in $(ls -1 "{{ REPO }}/home/s6/sv/" 2>/dev/null | grep -v '^default$'); do
                printf "    {{ OK }}start   {{ B }}%s{{ RST }}\n" "$name"
            done
        fi
    elif [ "{{ DRY }}" = "1" ]; then
        printf "    {{ DRF }}init    {{ DIM }}user s6-rc{{ RST }}\n"
    fi

# install packages from pkg/*
packages:
    #!/bin/sh
    printf "\n  {{ HDR }}packages{{ RST }}\n"
    found=0
    for file in "{{ REPO }}/pkg/"*; do
        [ -f "$file" ] || continue
        list=$(basename "$file")
        [ "$list" = "aur" ] && continue
        found=1
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}%s{{ RST }}\n" "$list"
            continue
        fi
        printf "    {{ OK }}install {{ B }}%s{{ RST }}\n" "$list"
        if [ "{{ YES }}" = "1" ]; then
            sudo pacman -S --needed --noconfirm - < "$file"
        else
            sudo pacman -S --needed - < "$file"
        fi
    done
    [ "$found" = "0" ] && printf "    {{ DIM }}(no lists found){{ RST }}\n" || true

# update pacman packages
pkg-update:
    #!/bin/sh
    printf "\n  {{ HDR }}pkg update{{ RST }}\n"
    if [ "{{ DRY }}" = "1" ]; then
        printf "    {{ DRF }}dry     {{ DIM }}pacman -Syu{{ RST }}\n"
        exit 0
    fi
    if [ "{{ YES }}" = "1" ]; then
        sudo pacman -Syu --noconfirm
    else
        sudo pacman -Syu
    fi

# install AUR packages
aur:
    #!/bin/sh
    printf "\n  {{ HDR }}aur{{ RST }}\n"
    pkgs=""
    for file in "{{ REPO }}/pkg/"aur*; do
        [ -f "$file" ] || continue
        pkgs="$pkgs $(sed '/^$/d;/^#/d' "$file" | tr '\n' ' ')"
    done
    pkgs=$(echo "$pkgs" | sed 's/^ *//;s/ *$//')
    [ -z "$pkgs" ] && printf "    {{ DIM }}(no packages){{ RST }}\n" && exit 0
    for pkg in $pkgs; do
        if pacman -Qi "$pkg" >/dev/null 2>&1; then
            printf "    {{ OK }}skip    {{ DIM }}%s{{ RST }}\n" "$pkg"
            continue
        fi
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}%s{{ RST }}\n" "$pkg"
            continue
        fi
        {{ REPO }}/scripts/aur -p "$pkg" install
    done

# update AUR packages (with security diff check)
aur-update:
    #!/bin/sh
    printf "\n  {{ HDR }}aur update{{ RST }}\n"
    pkgs=""
    for file in "{{ REPO }}/pkg/"aur*; do
        [ -f "$file" ] || continue
        pkgs="$pkgs $(sed '/^$/d;/^#/d' "$file" | tr '\n' ' ')"
    done
    pkgs=$(echo "$pkgs" | sed 's/^ *//;s/ *$//')
    [ -z "$pkgs" ] && printf "    {{ DIM }}(no packages){{ RST }}\n" && exit 0
    {{ REPO }}/scripts/aur -p "$pkgs" update

# enable s6 services
services:
    #!/bin/sh
    printf "\n  {{ HDR }}services{{ RST }}\n"
    found=0
    changed=0
    enabled=""
    for svc in {{ SERVICES }}; do
        found=1
        if [ -d "/etc/s6/adminsv/$svc" ]; then
            name="$svc"
        elif [ -d "/etc/s6/sv/${svc}-srv" ]; then
            name="${svc}-srv"
        else
            continue
        fi
        if s6-rc-db -c /etc/s6/rc/compiled contents default 2>/dev/null | grep -q "^${name}$"; then
            printf "    {{ OK }}skip    {{ DIM }}%s{{ RST }}\n" "$svc"
            continue
        fi
        changed=1
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}%s{{ RST }}\n" "$svc"
            continue
        fi
        printf "    {{ OK }}enable  {{ B }}%s{{ RST }}\n" "$svc"
        sudo s6 set enable "$svc"
        enabled="$enabled $svc"
    done
    if [ "$changed" = "1" ] && [ "{{ DRY }}" != "1" ]; then
        sudo s6 set commit
        sudo s6 live install
        for svc in $enabled; do
            sudo s6 live start "$svc" 2>/dev/null || true
            printf "    {{ OK }}started {{ B }}%s{{ RST }}\n" "$svc"
        done
    fi
    [ "$found" = "0" ] && printf "    {{ DIM }}(no services){{ RST }}\n" || true

# deploy everything
apply: user system user-services packages aur services
    #!/bin/sh
    if [ "{{ DRY }}" = "1" ]; then
        printf "\n  {{ DRF }}dry run complete{{ RST }}\n"
    else
        printf "\n  {{ OK }}apply complete{{ RST }}\n"
    fi

# list all tracked files
managed:
    #!/bin/sh
    printf "\n  {{ HDR }}managed files{{ RST }}\n\n"
    count=0
    for file in $(find "{{ REPO }}/home/config" -type f 2>/dev/null | sed "s|{{ REPO }}/home/config/||" | sort); do
        printf "    {{ DIM }}~/.config/%s{{ RST }}\n" "$file"
        count=$((count + 1))
    done
    for file in $(find "{{ REPO }}/home" -type f -not -path "{{ REPO }}/home/config/*" -not -path "{{ REPO }}/home/s6/*" 2>/dev/null | sed "s|{{ REPO }}/home/||" | sort); do
        printf "    {{ DIM }}~/%s{{ RST }}\n" "$file"
        count=$((count + 1))
    done
    for file in $(find "{{ REPO }}/etc" -type f -not -path "{{ REPO }}/etc/s6/*" 2>/dev/null | sed "s|{{ REPO }}/etc/||" | sort); do
        printf "    {{ DIM }}/etc/%s{{ RST }}\n" "$file"
        count=$((count + 1))
    done
    for name in $(ls -1 "{{ REPO }}/home/s6/sv/" 2>/dev/null | grep -v '^default$'); do
        printf "    {{ DIM }}~/.local/share/s6/sv/%s{{ RST }}\n" "$name"
        count=$((count + 1))
    done
    printf "\n    {{ DIM }}%d files tracked{{ RST }}\n" "$count"

# stop tracking a file (removes from repo, not from target)
forget file:
    #!/bin/sh
    target=$(echo "{{ file }}" | sed "s|^~|$HOME|")
    case "$target" in
        "$HOME/.config/"*)
            rel=${target#"$HOME/.config/"}
            repo="{{ REPO }}/home/config/$rel"
            label="~/.config/$rel"
            ;;
        "$HOME/"*)
            rel=${target#"$HOME/"}
            repo="{{ REPO }}/home/$rel"
            label="~/$rel"
            ;;
        "/etc/"*)
            rel=${target#"/etc/"}
            repo="{{ REPO }}/etc/$rel"
            label="/etc/$rel"
            ;;
        *)
            printf "    {{ ERR }}error{{ RST }}  unsupported path (must start with ~/, ~/.config/, or /etc/)\n" >&2
            exit 1
            ;;
    esac
    [ -e "$repo" ] || { printf "    {{ ERR }}error{{ RST }}  not tracked: %s\n" "$label" >&2; exit 1; }
    rm -rf "$repo"
    printf "    {{ DRF }}forgot   {{ B }}%s{{ RST }}\n" "$label"

# dry run everything (show what would happen)
dry:
    @just DRY=1 apply

# force overwrite existing targets
force target:
    @just FORCE=1 {{ target }}

# force overwrite everything
force-all:
    @just FORCE=1 apply

# auto-confirm all prompts
yes target:
    @just YES=1 {{ target }}

# check which deployed files have drifted from repo
status:
    #!/bin/sh
    printf "\n  {{ HDR }}drift check{{ RST }}\n\n"
    found=0
    total=0
    for file in $(find "{{ REPO }}/home/config" -type f 2>/dev/null | sed "s|{{ REPO }}/home/config/||" | sort); do
        src="{{ REPO }}/home/config/$file"
        dest="$HOME/.config/$file"
        total=$((total + 1))
        [ -e "$dest" ] || { printf "    {{ DRF }}missing  {{ B }}~/.config/%s{{ RST }}\n" "$file"; found=1; continue; }
        diff -rq "$src" "$dest" >/dev/null 2>&1 && { printf "    {{ DIM }}clean    ~/.config/%s{{ RST }}\n" "$file"; continue; }
        printf "    {{ DRF }}drifted  {{ B }}~/.config/%s{{ RST }}\n" "$file"
        found=1
    done
    for file in $(find "{{ REPO }}/home" -type f -not -path "{{ REPO }}/home/config/*" -not -path "{{ REPO }}/home/s6/*" 2>/dev/null | sed "s|{{ REPO }}/home/||" | sort); do
        src="{{ REPO }}/home/$file"
        dest="$HOME/$file"
        total=$((total + 1))
        [ -e "$dest" ] || { printf "    {{ DRF }}missing  {{ B }}~/%s{{ RST }}\n" "$file"; found=1; continue; }
        diff -rq "$src" "$dest" >/dev/null 2>&1 && { printf "    {{ DIM }}clean    ~/%s{{ RST }}\n" "$file"; continue; }
        printf "    {{ DRF }}drifted  {{ B }}~/%s{{ RST }}\n" "$file"
        found=1
    done
    for file in $(find "{{ REPO }}/etc" -type f -not -path "{{ REPO }}/etc/s6/*" 2>/dev/null | sed "s|{{ REPO }}/etc/||" | sort); do
        src="{{ REPO }}/etc/$file"
        dest="/etc/$file"
        total=$((total + 1))
        [ -e "$dest" ] || { printf "    {{ DRF }}missing  {{ B }}/etc/%s{{ RST }}\n" "$file"; found=1; continue; }
        diff -rq "$src" "$dest" >/dev/null 2>&1 && { printf "    {{ DIM }}clean    /etc/%s{{ RST }}\n" "$file"; continue; }
        printf "    {{ DRF }}drifted  {{ B }}/etc/%s{{ RST }}\n" "$file"
        found=1
    done
    printf "\n    "
    if [ "$found" = "0" ] && [ "$total" -gt 0 ]; then
        printf "{{ OK }}%d tracked, all in sync{{ RST }}\n" "$total"
    elif [ "$total" -eq 0 ]; then
        printf "{{ DIM }}nothing tracked{{ RST }}\n"
    else
        printf "{{ DRF }}%d tracked, some drifted{{ RST }}\n" "$total"
    fi

# show diffs between repo and deployed files
diff:
    #!/bin/sh
    printf "\n  {{ HDR }}diff{{ RST }}\n"
    shown=0
    for file in $(find "{{ REPO }}/home/config" -type f 2>/dev/null | sed "s|{{ REPO }}/home/config/||" | sort); do
        src="{{ REPO }}/home/config/$file"
        dest="$HOME/.config/$file"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        printf "\n    {{ DRF }}~/.config/%s{{ RST }}\n" "$file"
        diff --color=always -u "$src" "$dest" | sed 's/^/    /' || true
        shown=1
    done
    for file in $(find "{{ REPO }}/home" -type f -not -path "{{ REPO }}/home/config/*" -not -path "{{ REPO }}/home/s6/*" 2>/dev/null | sed "s|{{ REPO }}/home/||" | sort); do
        src="{{ REPO }}/home/$file"
        dest="$HOME/$file"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        printf "\n    {{ DRF }}~/%s{{ RST }}\n" "$file"
        diff --color=always -u "$src" "$dest" | sed 's/^/    /' || true
        shown=1
    done
    for file in $(find "{{ REPO }}/etc" -type f -not -path "{{ REPO }}/etc/s6/*" 2>/dev/null | sed "s|{{ REPO }}/etc/||" | sort); do
        src="{{ REPO }}/etc/$file"
        dest="/etc/$file"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        printf "\n    {{ DRF }}/etc/%s{{ RST }}\n" "$file"
        sudo diff --color=always -u "$src" "$dest" | sed 's/^/    /' || true
        shown=1
    done
    [ "$shown" = "0" ] && printf "\n    {{ OK }}no differences{{ RST }}\n" || printf "\n"

# list available targets
list:
    @just --list

# pull changes from deployed files back into repo
pull:
    #!/bin/sh
    printf "\n  {{ HDR }}pull{{ RST }}\n"
    found=0
    for file in $(find "{{ REPO }}/home/config" -type f 2>/dev/null | sed "s|{{ REPO }}/home/config/||" | sort); do
        src="{{ REPO }}/home/config/$file"
        dest="$HOME/.config/$file"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        mkdir -p "$(dirname "$src")"
        cp -rf "${dest}" "${src}"
        printf "    {{ OK }}pulled  {{ B }}~/.config/%s{{ RST }}\n" "$file"
        found=1
    done
    for file in $(find "{{ REPO }}/home" -type f -not -path "{{ REPO }}/home/config/*" -not -path "{{ REPO }}/home/s6/*" 2>/dev/null | sed "s|{{ REPO }}/home/||" | sort); do
        src="{{ REPO }}/home/$file"
        dest="$HOME/$file"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        mkdir -p "$(dirname "$src")"
        cp -rf "${dest}" "${src}"
        printf "    {{ OK }}pulled  {{ B }}~/%s{{ RST }}\n" "$file"
        found=1
    done
    for file in $(find "{{ REPO }}/etc" -type f -not -path "{{ REPO }}/etc/s6/*" 2>/dev/null | sed "s|{{ REPO }}/etc/||" | sort); do
        src="{{ REPO }}/etc/$file"
        dest="/etc/$file"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        sudo mkdir -p "$(dirname "$src")"
        sudo cp -rf "${dest}" "${src}"
        printf "    {{ OK }}pulled  {{ B }}/etc/%s{{ RST }}\n" "$file"
        found=1
    done
    [ "$found" = "0" ] && printf "    {{ DIM }}nothing to pull{{ RST }}\n" || true
