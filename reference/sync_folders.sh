rsync -Pauv '/run/media/user/New Volume/Backups/' /data/share02/Backups

# -P    show progress
# -a    archive: recurse, follow symlinks, preserve permissions, etc; basically what you want for a backup
# -u    only update newer
# -v    verbose