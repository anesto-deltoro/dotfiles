# ---------------- #
# Development zone #
# ---------------- #
alias gosand="cd ~/dev/personal/sandbox/"
alias gowork="cd ~/dev/work/"

# file editing
alias -s java='idea'  # open java file with idea
alias -s scala='idea' # open scala file with idea
alias -s json='code' # open json file with vscode

# Java Dev
# -
alias grcb="./gradlew clean build"
alias grr="./gradlew bootRun"
alias grj="./gradlew bootJar"
alias grtst="./gradlew test"
alias gri="./gradlew bootBuildImage"

alias mr="./mvnw spring-boot:run"

grr-jar(){
    profile=$1
    ./gradlew bootJar
    appName=$(cat settings.gradle | grep 'rootProject.name =' | cut -d "=" -f 2 | tr -d '[:blank:]' | tr -d "\'")
    version=$(cat build.gradle | grep 'version =' | cut -d "=" -f 2 | tr -d '[:blank:]' | tr -d "\'")
    java -jar build/libs/$appName-$version.jar --spring.profiles.active=$profile
}

arefresh(){
    let port=$1
    http POST :$port/actuator/refresh
}


# Java
# -
alias j22="jenv local 22; export JAVA_HOME=`/usr/libexec/java_home -v 22`; java -version"
alias j21="jenv local 21; export JAVA_HOME=`/usr/libexec/java_home -v 21`; java -version"
# alias j20="export JAVA_HOME=`/usr/libexec/java_home -v 20`; java -version"
# alias j19="export JAVA_HOME=`/usr/libexec/java_home -v 19`; java -version"
# alias j18="export JAVA_HOME=`/usr/libexec/java_home -v 18`; java -version"
alias j17="jenv local 17; export JAVA_HOME=`/usr/libexec/java_home -v 17`; java -version"
# alias j16="export JAVA_HOME=`/usr/libexec/java_home -v 16`; java -version"
# alias j15="export JAVA_HOME=`/usr/libexec/java_home -v 15`; java -version"
# alias j14="export JAVA_HOME=`/usr/libexec/java_home -v 14`; java -version"
# alias j13="export JAVA_HOME=`/usr/libexec/java_home -v 13`; java -version"
# alias j12="export JAVA_HOME=`/usr/libexec/java_home -v 12`; java -version"
alias j11="jenv local 11; export JAVA_HOME=`/usr/libexec/java_home -v 11`; java -version"
# alias j10="export JAVA_HOME=`/usr/libexec/java_home -v 10`; java -version"
# alias j9="export JAVA_HOME=`/usr/libexec/java_home -v 9`; java -version"
alias j8="jenv local 1.8; export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
# alias j7="export JAVA_HOME=`/usr/libexec/java_home -v 1.7`; java -version"

# Git
# -
# Revert last commit and keep changes locally
alias grlast=git reset --soft HEAD~1

# Go to master/main, update and create a new branch $1
gmnb() { gcm; gl; gco -b $1; }
# Fetch origin changes and merge then into current branch
gmo() {
  git fetch origin $1
  git merge origin/$1
}
# List files more frequently modified (commits)
gsfm() {
  git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -10
}
# List authors sorted by commit
gsac1() {
  git ls-files | while read f; do git blame --line-porcelain $f | grep '^author '; done | sort -f | uniq -ic | sort -n
}
gsac2() {
  git shortlog -sn --all
}
# Get commit count for specific folder
gscc() {
  git log --name-only --pretty=format: -- $1 | sort | uniq -c | head -n 1
}
# Git squash and commit vs current status of master. Commit message required as parameter
gsq() {
  CURRENT=`git rev-parse --abbrev-ref HEAD`;
  git reset $(git merge-base master $CURRENT)
  git add -A
  git commit -m $1
}
# Git squash and commit vs current status of a given branch. Commit message required as parameter
gsq2() {
  CURRENT=`git rev-parse --abbrev-ref HEAD`;
  git reset $(git merge-base $1 $CURRENT)
  git add -A
  git commit -m $2
}

# Misc
# -
alias quick-clean="find . -name target -exec rm -rf {} \;" # find and delete all directories named target starting from the current directory.

# Docker
# -
dkrr() {
  name=$(echo "$1" | cut -d ":" -f 1)
  docker run --rm --name $name -p$2:$2 --platform linux/amd64 $1
}

# Get latest container ID
alias dl="docker ps -l -q"
# List running containers (formatted)
alias dkps="docker ps --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
# List running containers (formatted)
alias dkpa="docker ps -a --format '{{.ID}} ~ {{.Names}} ~ {{.Status}} ~ {{.Image}}'"
# List containers stats (formatted)
dktop() {
  docker stats --format "table {{.Container}}\t{{.Name}}\t{{.CPUPerc}}  {{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
}
# Get images
alias dkim="docker images"
# Run interactive container, e.g., $dki base /bin/bash
alias dki="docker run -i -t -P"
# Execute interactive container, e.g., $dex base /bin/bash
alias dkex="docker exec -i -t"
# Stop all containers
dstop() { docker stop $(docker ps -a -q); }
# Remove all containers
drma() { docker rm $(docker ps -a -q); }
# Stop and Remove all containers
alias drmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
# Remove dangling images
dkrmdi() { docker rmi $(docker images --filter "dangling=true" -q --no-trunc) || true; }
# Remove all images
dkri() { docker rmi $(docker images -q); }
# Bash into running container
dkbash() { docker exec -it $(docker ps -aqf "name=$1") bash; }