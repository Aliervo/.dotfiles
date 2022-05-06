# .dotfiles
A remote back up of all my lovely dots

They were created using a bare git repository following [this atlassian post](https://www.atlassian.com/git/tutorials/dotfiles), which was in turn inspired by [this Hacker News comment](https://news.ycombinator.com/item?id=11071754)

A summary of the creation process:
```
git init --bare $HOME/.dotfiles
alias dotfiles='$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
```
The alias can then be added to the dots of your favorite shell for future use (and backed up in the repo).
```
dotfiles add /PATH/TO/FILE
dotfiles commit -m "Add FILE"
```
