# Ansible script to delpoy powershell webservice

## Usage

1. Customize the Ansible playbook `run_powershell_file.yml` by updating the following parameters:

* hosts: Replace your_windows_host with the hostname or IP address of the target Windows machine.
* src: Update the path to your `tcp-server.ps1` script file.
* dest: Specify the directory path on the remote Windows machine where you want to copy the script.
  
2. Configure `windows` [hosts](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
3. Run the Ansible playbook:

```
ansible-playbook web-server.yml -vvv --extra-vars "ansible_become_user={remote user} ansible_become_password={remote password}"
```


4. The playbook will copy the PowerShell script to the remote Windows machine and execute it. The output of the script will be displayed.
5. The webserver will start on ```http://localhost:5000/```. Call `/launch` endpoint to  launch to `create local user` and launch `notepad.exe`
