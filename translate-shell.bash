_complete_option() {
    COMPREPLY=($(compgen -W "$(trans -help -no-ansi \
        | awk '{\
            for (i = 1; i <= NF; i++) {\
                if (index($i, "-") == 1) {\
                    sub(/[,\.]$/, "", $i);\
                    print $i\
                }\
            }\
        }')" -- "$cur"))
}

_complete_engine() {
    COMPREPLY=($(compgen -W "$(trans -list-engines | awk '{ print gensub(/ |\*/, "", "g") }')" -- "$cur"))
}

_complete_language() {
    COMPREPLY=($(compgen -W "$(trans -list-codes; trans -list-languages; trans -list-languages-english | sort)" -- "$cur"))
}

_has_language_delimiter() {
    case "$cur" in
        *[:=]*)
            true
            ;;
        *)
            false
            ;;
    esac
}

_translate() {
    COMPREPLY=()
    cur="$(_get_cword)"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [ "${prev:0:1}" = "-" ]; then
        case "$prev" in
            -s|-sl|-source|-from|-t|-tl|-target|-to)
                _complete_language
                ;;
            -e|-engine)
                _complete_engine
                ;;
        esac
    elif [ "${cur:0:1}" = "-" ]; then
        _complete_option
    # Complete shorcut formatted languages.
    elif _has_language_delimiter; then
        # Remove first language and/or delimiter.
        cur="${cur/*[:=]/}"
        _complete_language
    else
        _complete_language
    fi

    return 0
} &&
complete -F _translate default trans
