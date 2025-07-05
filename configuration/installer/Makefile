# TODO: This is just a collection of thoughts. Need to make it a real Makefile or maybe a Justfile
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /etc/disko/disk1-b-r-zfs.nix

# download nixos's sops key
curl https://thebrain.looniversity.net:${secretsPort}/sops/private/nixos/age.key -o /home/nixos/.config/sops/age/keys.txt

# Update sops configuration
key=$(ssh-keyscan -t ed25519 127.0.0.1 | ssh-to-age)
yq -y ".creation_rules[0].key_groups[0].age += [\"$(echo $key)\"] | .keys += [\"$(echo $key)\"]" .sops.yaml > .sops.yaml
