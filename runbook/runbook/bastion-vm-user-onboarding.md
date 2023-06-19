## Bastion VM User Onboarding Steps

1. Due to the restricted shell and the setup of the Bastion VM a user will need to be onboarded in a multi-step process.
1. The reason for this is that users have POSIX information assigned to their OS Login identity only after they login to a VM that has OS Login enabled.
1. This information is maintained in a LDAP in GCP behind the scenes.
1. Certain services need to be updated after that user attempts to login so that the LDAP entries on the VM are updated. This step is necessary for the user to SSH out of the Bastion VM and into the Workspace VM.
1. The commands can be found in `sde-user-onboarding-final.sh` which is located in the SRDE `researcher-projects` directory as a reference.
1. There are two files that will need to be added manually into the VM in order to onboard research group users.
1. The `sde-user-onboarding-initial.sh` is the first file to add onto the VM and update.
1. As a pre-requisite ensure that the administrator has `roles/compute.osAdminLogin`. This is necessary for superuser privileges.
1. The following steps are performed only by administrators of the GCE VM.
    1. Initial Onboarding Step
        1. Login to the VM.
        1. Create a file called `sde-user-onboarding-initial.sh`.
        1. Copy the contents of `sde-user-onboarding-initial.sh` from this repository into the file on the VM.
        1. Update the `USER` variable towards the top of the script with the OS Login username of the individual being onboarded.
        1. Save the file on the VM and make the shell script an executable file.
        1. Run the sde-user-onboarding-initial.sh script.
        1. After this step is done the users home directory will be created. Users can login to the VM prior to this step being done and they will be given a restricted shell even if they do not have a home directory. The only exception to this is if they are exempt from the restricted shell which is defined in the Bastion VM Startup Script section above.
        1. Ask the user to login to the VM then log out.
    1. Final Onboarding Step
        1. Create a file called `sde-user-onboarding-final.sh`.
        1. Copy the contents of `sde-user-onboarding-final.sh` from this repository into the file on the VM.
        1. Update the `USER` variable towards the top of the script with the OS Login username of the individual being onboarded.
        1. Save the file on the VM and make the shell script an executable file.
        1. Run the sde-user-onboarding-initial.sh script.
        1. Ask the user to login to the VM and attempt to SSH to the Workspace VM using a normal SSH command.
            1. `ssh <WORKSPACE_VM_IP>`
        1. The Workspace VM will have a defined static internal IP which is defined in the `.tfvars` file of this directory.