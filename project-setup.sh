#!/bin/bash

#  
# Simple script to easily deploy to multiple environments
# on Heroku when code is hosted on a remote git repo 
#

if ! [ -d .git ]; then
  echo "This is not a git repo..."
  echo "You sure you're in the base directory for your project?"
  exit -1
fi;

git ls-remote origin
if test $? != 0; then
  echo "No remote origin, push code to remote repo and try again"
  exit -1
fi;

read -p "Do you want to create develop and staging branches? Y or N" -n 1 -r 
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Creating develop branch and pushing to origin"
  git checkout master
  git checkout -b staging
  git push origin staging
  git checkout -b develop
  git push origin develop
fi

read -p "Do you want to create development, staging, and production heroku apps? Y or N" -n 1 -r 
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  heroku_user="$(heroku auth:whoami)"
  echo "You are currently logged in as $heroku_user"
  echo 
  echo "A development, staging, and production heroku applications will be created."
  echo "They will be prepended with '{app_name}-develop/staging/production'"
  echo "  app -> app-development"
  echo "      -> app-staging"
  echo "      -> app-produciton"
  echo "What would you like to call your app?"
  read app_name
  if [[ -n "$app_name" ]]; then
    heroku create $app_name-development --remote development
    heroku create $app_name-staging --remote staging
    heroku create $app_name-production --remote production
    if test $? !=0; then
      echo "Heroku app name taken"
    fi
  fi 
fi

read -p "Do you want to create development, staging, and production heroku remotes? Y or N" -n 1 -r 
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  heroku_user="$(heroku auth:whoami)"
  echo "You are currently logged in as $heroku_user"
  echo 
  echo "Here is a list of your apps on heroku:"
  echo 
  heroku apps
  echo 
  echo "What app would you like to add remotes for? [Don't include environments]"
  read app_name
  if [[ -n "$app_name" ]]; then
    git remote rm development
    git remote rm staging
    git remote rm production
    heroku git:remote -a $app_name-development -r development
    heroku git:remote -a $app_name-staging -r staging
    heroku git:remote -a $app_name-production -r production
  fi
fi

read -p "Do you want to create create a procfile for web deployment to heroku? Y or N" -n 1 -r 
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "web: bundle exec passenger start -p $PORT" > Procfile
  echo
  echo "Make sure you have the 'passenger' gem in the production group of your gemfile."
  echo "Also make sure you have the 'rails_12factor' gem in the production group of your gemfile"
fi

read -p "Do you want to add a collaborator to the heroku apps? Y or N" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "What email would you like to add as a collaborator"
  read collaborator_email
  echo "What is the name of your app?"
  read app_name
  heroku sharing:add $collaborator_email --app $app_name-development
  heroku sharing:add $collaborator_email --app $app_name-staging
  heroku sharing:add $collaborator_email --app $app_name-production
fi


# read -p "Do you want to create a Readme? Y or N" -n 1 -r
# echo 
# if [[ $REPLY =~ ^[Yy]$ ]]
# then
#   cat > README.md << EOL
#   line 1, \#\# System Requirements
#   line 2, 
#   line 3, Please make a list of any system requirements. Java version, Ruby versions, SDKs
#   line 4, 
#   line 5, \#\# Getting Started
#   line 6, 
#   line 7, git clone [repository]
#   line 8, rake db:migrate
#   line 9, rails server
#   line 10, 
#   EOL
# fi

