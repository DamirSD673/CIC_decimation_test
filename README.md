# Welcome to the Project 
## 1. Clone Project

`git clone https://github.com/DamirSD673/CIC_decimation_test.git <dir_where_you_want_to_clone_to>`

## 2. Reconstruct the project
* Open Vivado GUI
* Open Vivado Terminal and find the path with cloned repo  
 `cd <path_with_tcl_file>`
* Run .tcl file with following command  
 `source <file>.tcl`  
Tip: Path to the .tcl file must only contain latin letters

 ## 3. Adding changes to git
 All project files are stored in **_CIC_test_sources_** folder
 
 **_.tcl_** script generates sandbox *_.xpr_* of the project based on files from **_CIC_test_sources_** folder
 
 Source files should be saved in **_CIC_test_sources_** folder
 * Block diagrams should be in **_bd_** folder
 * HDL sources should be in **_hdl_** folder
 * Constraints files should be in **_constraints_** folder
 * All IP-cores should be saved in **_ip_core_** folder

 ## 4. Writing .tcl file
 With adding new files it's better to rerun the .tcl script
 * Open _File_->_Project_->_Write Tcl_
 * Rewrite Current .tcl file
 
