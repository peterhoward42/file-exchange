PS1='\w\$ '


alias dbox="cd ~/Dropbox"
alias dbooku="vi ~/Dropbox/time-series/2020-01-xxxx-unai/daybook.txt"
alias dbookh="vi ~/Dropbox/time-series/2020-06-xxxx-hsbc/daybook.txt"
alias safe="cd ~/Dropbox/projects/computing_projects/hsbc"


alias storgen="cd ~/repos/storgen"


# Path

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/go/bin:/Users/test/go/bin


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/test/google-cloud-sdk/path.bash.inc' ]; then . '/Users/test/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/test/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/test/google-cloud-sdk/completion.bash.inc'; fi
