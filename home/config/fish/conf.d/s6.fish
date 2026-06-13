if status --is-login
    set -l s6_session ~/.local/share/s6/start-session
    if test -x $s6_session
        $s6_session &
        disown
    end
end
