for arg in "$@"; do
    case "$arg" in
        "-u") # unmount & undo changes
            unmountDir 5
            ;;
        "-p") # copie everything to preset
            if mountpoint -q "$MOUNTDIR"; then
                rsync -ar "$MOUNTDIR/." "$WORKINGDIR/preset"
            fi
            ;;
        "-f") # starting firefox
            firefoxStart
            ;;
        *)
            echo "Argument *$arg* unknown"
            ;;
    esac
done