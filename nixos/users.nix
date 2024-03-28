{ ... }:

{
  users.users = {
    prase = {
      initialPassword = "lesvabi";
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [
        # Daníkův klíč
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKc7hBSDeDPZ0IsxfHaQZ7Adfug5H1h+dDYu2sML+8Pp wikiker@DanikuvkBucek22.COMFAST"
      ];
    };
  };
}
