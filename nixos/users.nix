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
        # Petrův klíč
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII7085N6oPvLplV8f4B9qILS8GXBPXi4Dk0kaR7I04Gy lolec@Martin"
        # Radkův klíč
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfB/oj8WLrpKKwTVJloPGudCq2XWeqb8NP4oe1Ocqt7 radek@tauros"
      ];
    };
  };
}
