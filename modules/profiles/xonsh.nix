{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.profiles.xonsh;

  bash_completion = pkgs.writeScript "xonsh-complete.sh" ''
    . ${pkgs.bash-completion}/share/bash-completion/bash_completion
    for p in $NIX_PROFILES; do
      for m in "$p/etc/bash_completion.d/"*; do
        . $m
      done
    done
  '';

  pythonEnv = (pkgs.python3.buildEnv.override {
    extraLibs = cfg.pythonPackages;
  });
in {
  options.profiles.xonsh = {
    enable = mkEnableOption "xonsh profile";

    pythonPackages = mkOption {
      description = "xonsh python packages";
      type = types.listOf types.package;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    programs.xonsh.enable = true;

    system.activationScripts.remove-xonsh-cache = ''
      rm -r ${config.users.users.admin.home}/.local/share/xonsh/xonsh_script_cache
    '';

    programs.xonsh.config = ''
      import sys
      import os
      import json
      import platform
      import xonsh.dirstack as xds
      from os import listdir
      from os.path import join
      from operator import itemgetter
      from prompt_toolkit.keys import Keys
      from prompt_toolkit.filters import Condition
      from prompt_toolkit.completion import Completion
      from prompt_toolkit.document import Document

      hist_dir = __xonsh_env__['XONSH_DATA_DIR']

      # docs http://python-prompt-toolkit.readthedocs.io/en/master/pages/reference.html

      # expose python site packages
      sys.path.append('${pythonEnv}/lib/${pkgs.python3.libPrefix}/site-packages')

      history_search_state = {
        'text': None,
        'history': []
      }

      def autojump_add_to_database():
        $[autojump --add $PWD]

      def prompt(postString = None):
        return "{BOLD_PURPLE}λ "

      def rprompt(seconds = 0, telepresence_pod = None, rtn = 0):
        postString = ""
        if seconds > 1:
          postString += ' {BOLD_WHITE}[{BOLD_BLUE}'+str(seconds)+'s{BOLD_WHITE}]{NO_COLOR}'

        if telepresence_pod is not None:
          postString += ' {BOLD_WHITE}[{RED}telepresence{BOLD_WHITE}]{NO_COLOR}'

        if rtn is not 0:
          postString += ' {BOLD_WHITE}[{BOLD_RED}' + str(rtn) + '↵{BOLD_WHITE}]{NO_COLOR}'


        return "{BOLD_RED}{gitstatus} {BOLD_BLUE}{cwd: {}}" + postString

      def title(cmd = "{current_job}"):
        line = "{short_cwd}"
        if cmd is not None:
          return line + " " + cmd
        else:
          return line

      def del_duplicates(seq):
        seen = set()
        seen_add = seen.add
        return [x for x in seq if not (x in seen or seen_add(x))]

      def getHistory(text = ""):
        files = [join(hist_dir,f) for f in listdir(hist_dir)
                if f.startswith('xonsh-') and f.endswith('.json')]

        fileHist = [json.load(open(f))['data']['cmds'] for f in files]

        commands = [(c['inp'].replace('\n', ""), c['ts'][0])
                    for commands in fileHist for c in commands if c]

        commands.sort(key=itemgetter(1))

        numOfCommands = len(commands)
        digits = len(str(numOfCommands))

        return [c[0] for c in commands if c[0].find(text) != -1]

      @events.on_ptk_create
      def custom_keybindings(bindings, **kw):
        handler = bindings.registry.add_binding

        @Condition
        def has_text(cli):
          return len(cli.current_buffer.document.text) != 0

        @handler(Keys.ControlR, filter=has_text)
        def history_search_activate(event):
          history_search_state['text'] = event.cli.current_buffer.document.text
          history_search_state['history'] = del_duplicates(getHistory(text=history_search_state['text']))
          history_search_state['history'].reverse()
          completions = [Completion(text=t, start_position=(len(history_search_state['text'])*-1)) for t in history_search_state['history']]
          event.cli.current_buffer.set_completions(completions)
          
      @events.on_precommand
      def preexec(cmd):
        autojump_add_to_database()

      def j(args):
        result = $(autojump @(args)).strip()

        if os.path.isdir(result):
          print(result)
          !(cd @(result))
        else:
          print('autojump directory {} not found'.format(' '.join(args)))
          print(result)
          print('Try `autojump --help` for more information.')

      def pull_request(args=[], stdin=None):
        !(git push origin -f --set-upstream)
        $address = $(hub pull-request) if len(args) == 0 else $(hub pull-request -h @(args[0]))
        xdg-open "$address"

      aliases['j'] = j
      aliases['pull-request'] = pull_request

      $AUTOJUMP_SOURCED = '1'
      $PROMPT = prompt()
      $RIGHT_PROMPT = rprompt()
      $TITLE = title()
      $BASH_COMPLETIONS = '${bash_completion}'
      $XONSH_COLOR_STYLE = 'rrt'
      $DYNAMIC_CWD_WIDTH = '40%'
      $DYNAMIC_CWD_ELISION_CHAR = '…'
    '';
  };
}
