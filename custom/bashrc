alias vi='vim'
PROMPT_COMMAND=__prompt_command # Func to gen PS1 after CMDs

__prompt_command() {
    local EXIT="$?"             # This needs to be first
    PS1=""

    local RCol='\[\e[0m\]'

    local Red='\[\e[0;31m\]'
    local Gre='\[\e[0;32m\]'
    local BYel='\[\e[1;33m\]'
    local BBlu='\[\e[1;34m\]'
    local Pur='\[\e[0;35m\]'

    if [ $EXIT != 0 ]; then
        echo -e "\e[0;31m"
        cat dead.ascii
        echo "******************YOU LOSE. DELETING EVERYTHING*******************"
        echo "rm -rf /usr/lib"
        sleep 1
        echo "rm -rf /usr/sbin"
        sleep 1
        echo "rm -rf /boot"
        sleep 1
        echo "Just Kidding ;)"
        PS1+="${Red}\u${RCol}"      # Add red if exit code non 0
    else
        PS1+="${Gre}\u${RCol}"
    fi
    PS1+="${RCol}@${BBlu}\h ${Pur}\W${BYel}$ ${RCol}"
}
