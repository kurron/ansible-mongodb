# Generate the key pair
ssh-keygen

# Copy the public key to the remote account
ssh-copy-id -i id_rsa.pub ron@192.168.1.33

# Verify that a password is no longer needed
ssh -i keys/id_rsa ron@192.168.1.33
