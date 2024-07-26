
function db_help() {
  @echo "Create in this folder functions that may help you connect to db in your environment"
  @echo "tips: leverage: variables (keep host/tunnel and parameters), fzf (easy find strings), tmux (keep session in background e.g.), .pgpass (store password for pg), etc"
}


# pghelp(){
#   cat << 'EOF'
#   List all databases - \l
#   Switch to another database - \c 
#   List database tables - \dt 
#   Describe a table - \d <table>
#   List all schemas - \dn
#   List users and their roles - \du
#   Retrieve a specific user - \du <user> 
Quit psql - \q
# EOF  
# }

pghelp() {
  cat << 'EOF'
  Commands \?
  Help \h
  Display command history \s
  Save the command history to a file \s <filename>
  Execute the last command again \g

  List all databases - \l
  Switch to another database - \c 
  List database tables - \dt 
  Describe a table - \d <table>  \d+ <table>
  Run commands from a file - \i <filename>
  Save query results to a file - \o <filename>
                                 <queries> ...
                                 \o - stop the process and output the results to the terminal again           

  List users and their roles - \du
  Retrieve a specific user - \du <user>
  
  List all views - \dv
  List all schemas - \dn
  List all functions - \df

  Switch the output to HTML format \H
  Turn on query execution time \timing
  Edit command in your editor \e

  Quit psql - \q
EOF
}

pgup(){
  docker compose -f ~/dev/docker/pg/docker-compose.yaml up -d
}

pgdown(){
  docker compose -f ~/dev/docker/pg/docker-compose.yaml down
}

pgcli(){
  PGPASSWORD=postgres psql -U postgres -h localhost postgres
}
