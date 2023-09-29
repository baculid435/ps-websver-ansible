# Ansible script to delpoy powershell webservice

## Usage

1. Customize the Ansible playbook `web-server.yml.yml` by updating the following parameters:

* [hosts](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html): Replace `windows` with the hostname or IP address of the target Windows machine.
* dest: Specify the directory path on the remote Windows machine where you want to copy the script (optional).
  
2. Run the Ansible playbook:

```
ansible-playbook web-server.yml --extra-vars "ansible_become_user={remote user} ansible_become_password={remote password}"
```
3. The playbook will copy the PowerShell script to the remote Windows machine and execute it. The output of the script will be displayed.
4. The webserver will start on ```http://localhost:5000/```. Call `/launch` endpoint to  launch to `create local user` and launch `notepad.exe`
