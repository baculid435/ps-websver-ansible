# userGen-notepad-launcher

## Usage

1. Customize the Ansible playbook `run_powershell_file.yml` by updating the following parameters:

* hosts: Replace your_windows_host with the hostname or IP address of the target Windows machine.
* src: Update the path to your `tcp-server.ps1` script file.
* dest: Specify the directory path on the remote Windows machine where you want to copy the script.
  
2. Run the Ansible playbook:

```
ansible-playbook web-server.yml
```


3. The playbook will copy the PowerShell script to the remote Windows machine and execute it. The output of the script will be displayed.
