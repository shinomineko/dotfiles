alias bscp="scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias bssh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias bsshpass="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PubkeyAuthentication=no -o PreferredAuthentications=password"
alias untar="tar -xvf"
alias vim="nvim"

abbr --add --global dc "docker compose"
abbr --add --global k kubectl

function dif
    if type -q delta
        delta -s $argv
    else
        diff -y $argv | less -FNRX
    end
end

function mkd
    mkdir -p $argv
    cd $argv || exit
end

function tmpd
    set -l dir
    if test (count $argv) -eq 0
        set dir (mktemp -d)
    else
        set dir (mktemp -d -t "$argv[1].XXXXXXXXXX")
    end
    cd $dir
end

function tre
    tree -aC -I '.git' --dirsfirst $argv | less -FRX
end

function aws
    docker run -it --rm \
        -v "$HOME/.aws:/root/.aws:ro" \
        -e AWS_DEFAULT_REGION \
        -e AWS_ACCESS_KEY_ID \
        -e AWS_SECRET_ACCESS_KEY \
        -e AWS_SESSION_TOKEN \
        --log-driver none \
        amazon/aws-cli $argv
end
