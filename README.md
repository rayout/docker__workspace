If you have permissions problems:
1) Run `id` on HOST machine and run `id` on DOCKER machine. If they doesn`t math go next.
2) docker exec -it <container_workspace> zsh
3) Run - `usermod -u <ID_FROM_HOST> workspace`
4) RUN - `groupmod -g <ID_FROM_HOST> workspace`
5) restart container