# name: clearance
# ---------------
# Based on idan. Display the following bits on the left:
# - Virtualenv name (if applicable, see https://github.com/adambrenecki/virtualfish)
# - Current directory name
# - Git branch and dirty state (if inside a git repo)

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _git_tag
  echo (command git rev-parse --short HEAD ^ /dev/null)
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  set -l cwd $blue(pwd | sed "s:^$HOME:~:")

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Display [venvname] if in a virtualenv
  if set -q VIRTUAL_ENV
      echo -n -s (set_color -b cyan black) '[' (basename "$VIRTUAL_ENV") ']' $normal ' '
  end

  # Print pwd or full path
  echo -n -s $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)
    set -l git_tag (_git_tag)

    set git_info '('
    if [ (_git_is_dirty) ]
      set git_info $git_info $yellow $git_branch "±" $normal
    else
      set git_info $git_info $green $git_branch $normal
    end
    set git_info $git_info ':' $magenta $git_tag $normal
    set git_info $git_info $normal ')'

    echo -n -s ' ' $git_info $normal
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s '⟩ ' $normal
end
