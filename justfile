REPO := justfile_directory()
FORCE := "0"
DRY := "0"
YES  := "0"

USER_CONFIGS := "wezterm tmux"
HOME_CONFIGS := ""
ETC_CONFIGS  := "fstab hostname"
USER_S6      := "pipewire pipewire-pulse wireplumber"
SERVICES     := "iwd dbus user-services"
PKG_LISTS    := "base desktop"
AUR_LISTS    := "aur"

HDR := '\033[1;36m'
OK  := '\033[0;32m'
DRF := '\033[0;33m'
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
    [ -e "{{ dest }}" ] && rm -rf "{{ dest }}"
    cp -rf "{{ src }}" "{{ dest }}"
    printf "    {{ OK }}deploy  {{ B }}%s{{ RST }}\n" "$short"

# deploy user configs (~/.config/*)
user:
    #!/bin/sh
    printf "\n  {{ HDR }}user{{ RST }}  {{ DIM }}~/.config{{ RST }}\n"
    for name in {{ USER_CONFIGS }}; do just FORCE={{ FORCE }} _deploy "{{ REPO }}/home/config/$name" "$HOME/.config/$name"; done
    for name in {{ HOME_CONFIGS }}; do just FORCE={{ FORCE }} _deploy "{{ REPO }}/home/$name" "$HOME/$name"; done

# deploy system configs (/etc/*)
system:
    #!/bin/sh
    printf "\n  {{ HDR }}system{{ RST }}  {{ DIM }}/etc{{ RST }}\n"
    for name in {{ ETC_CONFIGS }}; do
        dest="/etc/$name"
        if [ "{{ FORCE }}" = "0" ] && [ -e "$dest" ]; then
            printf "    {{ OK }}skip    {{ DIM }}/etc/%s{{ RST }}\n" "$name"
            continue
        fi
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}/etc/%s{{ RST }}\n" "$name"
            continue
        fi
        [ -e "$dest" ] && sudo rm -rf "$dest"
        sudo cp -rf "{{ REPO }}/etc/$name" "$dest"
        printf "    {{ OK }}deploy  {{ B }}/etc/%s{{ RST }}\n" "$name"
    done
    for item in adminsv config; do
        src="{{ REPO }}/etc/s6/$item"
        dest="/etc/s6/$item"
        if [ "{{ FORCE }}" = "0" ] && [ -d "$dest" ] && diff -rq "$src" "$dest" >/dev/null 2>&1; then
            printf "    {{ OK }}skip    {{ DIM }}/etc/s6/%s{{ RST }}\n" "$item"
            continue
        fi
        if [ "{{ DRY }}" = "1" ]; then
            printf "    {{ DRF }}dry     {{ DIM }}/etc/s6/%s{{ RST }}\n" "$item"
            continue
        fi
        sudo cp -rf "$src"/* "$dest"/
        printf "    {{ OK }}deploy  {{ B }}/etc/s6/%s{{ RST }}\n" "$item"
    done
    if [ "{{ DRY }}" != "1" ]; then
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
    for name in {{ USER_S6 }}; do
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
    if [ -d "/run/$USER/s6-rc" ]; then
        if [ "{{ DRY }}" = "1" ]; then
            for name in {{ USER_S6 }}; do
                printf "    {{ DRF }}start   {{ DIM }}%s{{ RST }}\n" "$name"
            done
        else
            s6-rc -l /run/$USER/s6-rc -up change default 2>/dev/null || true
            for name in {{ USER_S6 }}; do
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
    for list in {{ PKG_LISTS }}; do
        file="{{ REPO }}/pkg/$list"
        [ -f "$file" ] || continue
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
    for list in {{ AUR_LISTS }}; do
        file="{{ REPO }}/pkg/$list"
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
    for list in {{ AUR_LISTS }}; do
        file="{{ REPO }}/pkg/$list"
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
        case "$svc" in
            user-services)
                [ -d "/etc/s6/adminsv/$svc" ] || continue
                if s6-rc-db -c /etc/s6/rc/compiled contents default 2>/dev/null | grep -q "^${svc}$"; then
                    printf "    {{ OK }}skip    {{ DIM }}%s{{ RST }}\n" "$svc"
                    continue
                fi
                ;;
            *)
                [ -d "/etc/s6/sv/${svc}-srv" ] || continue
                if s6-rc-db -c /etc/s6/rc/compiled contents default 2>/dev/null | grep -q "^${svc}-srv$"; then
                    printf "    {{ OK }}skip    {{ DIM }}%s{{ RST }}\n" "$svc"
                    continue
                fi
                ;;
        esac
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

# run everything
all: user system user-services packages aur services

# dry run everything (show what would happen)
dry:
    @just DRY=1 all

# force overwrite existing targets
force target:
    @just FORCE=1 {{ target }}

# force overwrite everything
force-all:
    @just FORCE=1 all

# auto-confirm all prompts
yes target:
    @just YES=1 {{ target }}

# check which deployed files have drifted from repo
status:
    #!/bin/sh
    printf "\n  {{ HDR }}drift check{{ RST }}\n\n"
    found=0
    total=0
    for name in {{ USER_CONFIGS }}; do
        src="{{ REPO }}/home/config/$name"
        dest="$HOME/.config/$name"
        total=$((total + 1))
        [ -e "$dest" ] || { printf "    {{ DRF }}missing  {{ B }}~/.config/%s{{ RST }}\n" "$name"; found=1; continue; }
        diff -rq "$src" "$dest" >/dev/null 2>&1 && { printf "    {{ DIM }}clean    ~/.config/%s{{ RST }}\n" "$name"; continue; }
        printf "    {{ DRF }}drifted  {{ B }}~/.config/%s{{ RST }}\n" "$name"
        found=1
    done
    for name in {{ HOME_CONFIGS }}; do
        src="{{ REPO }}/home/$name"
        dest="$HOME/$name"
        total=$((total + 1))
        [ -e "$dest" ] || { printf "    {{ DRF }}missing  {{ B }}~/%s{{ RST }}\n" "$name"; found=1; continue; }
        diff -rq "$src" "$dest" >/dev/null 2>&1 && { printf "    {{ DIM }}clean    ~/%s{{ RST }}\n" "$name"; continue; }
        printf "    {{ DRF }}drifted  {{ B }}~/%s{{ RST }}\n" "$name"
        found=1
    done
    for name in {{ ETC_CONFIGS }}; do
        src="{{ REPO }}/etc/$name"
        dest="/etc/$name"
        total=$((total + 1))
        [ -e "$dest" ] || { printf "    {{ DRF }}missing  {{ B }}/etc/%s{{ RST }}\n" "$name"; found=1; continue; }
        diff -rq "$src" "$dest" >/dev/null 2>&1 && { printf "    {{ DIM }}clean    /etc/%s{{ RST }}\n" "$name"; continue; }
        printf "    {{ DRF }}drifted  {{ B }}/etc/%s{{ RST }}\n" "$name"
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
    for name in {{ USER_CONFIGS }}; do
        src="{{ REPO }}/home/config/$name"
        dest="$HOME/.config/$name"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        printf "\n    {{ DRF }}~/.config/%s{{ RST }}\n" "$name"
        diff --color=always -u "$src" "$dest" | sed 's/^/    /' || true
        shown=1
    done
    for name in {{ HOME_CONFIGS }}; do
        src="{{ REPO }}/home/$name"
        dest="$HOME/$name"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        printf "\n    {{ DRF }}~/%s{{ RST }}\n" "$name"
        diff --color=always -u "$src" "$dest" | sed 's/^/    /' || true
        shown=1
    done
    for name in {{ ETC_CONFIGS }}; do
        src="{{ REPO }}/etc/$name"
        dest="/etc/$name"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        printf "\n    {{ DRF }}/etc/%s{{ RST }}\n" "$name"
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
    for name in {{ USER_CONFIGS }}; do
        src="{{ REPO }}/home/config/$name"
        dest="$HOME/.config/$name"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        rm -rf "$src"
        cp -rf "${dest}" "${src}"
        printf "    {{ OK }}pulled  {{ B }}~/.config/%s{{ RST }}\n" "$name"
        found=1
    done
    for name in {{ HOME_CONFIGS }}; do
        src="{{ REPO }}/home/$name"
        dest="$HOME/$name"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        rm -rf "$src"
        cp -rf "${dest}" "${src}"
        printf "    {{ OK }}pulled  {{ B }}~/%s{{ RST }}\n" "$name"
        found=1
    done
    for name in {{ ETC_CONFIGS }}; do
        src="{{ REPO }}/etc/$name"
        dest="/etc/$name"
        [ -e "$dest" ] || continue
        diff -rq "$src" "$dest" >/dev/null 2>&1 && continue
        sudo rm -rf "$src"
        sudo cp -rf "${dest}" "${src}"
        printf "    {{ OK }}pulled  {{ B }}/etc/%s{{ RST }}\n" "$name"
        found=1
    done
    [ "$found" = "0" ] && printf "    {{ DIM }}nothing to pull{{ RST }}\n" || true
