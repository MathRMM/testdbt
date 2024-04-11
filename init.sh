if [ ! -d "$HOME/.dbt" ]; then
  sudo mkdir -p "$HOME/.dbt";
fi
sudo mv ./profiles.yml "$HOME/.dbt/"

dbt debug