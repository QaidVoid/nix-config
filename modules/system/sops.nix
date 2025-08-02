{ ... }:
{
  sops = {
    # age.sshKeyPaths = [ "/home/qaidvoid/.ssh/id_ed25519" ];
    age.keyFile = "/home/qaidvoid/.config/sops/age/keys.txt";
    secrets = {
      cloudflare_token = {};
    };
  };
}
