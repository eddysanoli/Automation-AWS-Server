# Run the Terraria Server Executable
# NOTE: The "TERRARIA_VERSION" variable is replaced by the actual version
# (1.4.4.9 -> 1449) when the "provisioning.yaml" Ansible playbook runs. It 
# will replace the variable by the "terraria_version" variable specified at 
# the top of the YAML file.
./$TERRARIA_VERSION/Linux/TerrariaServer.bin.x86_64 -config serverconfig.txt