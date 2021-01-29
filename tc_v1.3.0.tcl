#----------------------------------------------------------------------
#>@brief Display the VMD "dynamic" Field (beta, charge, occupancy, ...)"
#>       Laboratory of Theoretical Chemistry - LQT
#>@e-mail bug report to: aslozada@gmail.com
#>@note Revision history 
#       07.11.2018
#       14.11.2018 Release v_1.1.0
#       22.11.2018 Release v_1.2.0
#       31.08.2020 Release v_1.3.0
#       Note: A Render is obtained with TachyonInternal 
#---------------------------------------------------------------------
#!/usr/bin/tclsh

set PROG_NAME tc.tcl
set VERSION v1.3.0

proc display_usage {name argc} {
     if { $argc < 0 } {
        puts ""
        puts "Not enough arguments in command line."
        puts "Usage: vmd -xyz <file.xyz> -e $name -args -f <field-file> "
        puts ""
        puts "Options:"
        puts "-h         Display this help."
        puts "-v         Display the version of script."
        puts "-f <field> Name field data file."
        puts "-r (0|1)   Enable render"
        puts ""
        exit
     }
}

proc display_version {name version} {
    puts "$name $version"
    puts "License GPLv3+: GNU GPL version 3 or later <http://gnu.org/license/gpl.html>."
    puts "This a free software: you are free to change and redistributibe it."
    puts "There is NO WARRANTY, to the extent permited by law."
    puts ""
    puts "Laboratory of Theoretical Chemistry, LQT -- UFSCar"
    puts "e-mail: Report bug to: e-mail: aslozada@gmail.com"
    puts ""
    exit
}

proc draw_field {data} {

     set data_exists [file exist $data]

     if { $data_exists == 0 } {
         puts "No such file: $data. Check the name file."
         exit
     }

     set data_name [open $data r]

     set numframes [molinfo top get numframes]
     set numatoms  [molinfo top get numatoms]

     set min 9999.9
     set max -9999.9

     for {set k 0} {$k<($numatoms)} {incr k} {
         set min_tmp [gets $data_name]
     
         if { $min_tmp < $min } {
            set min $min_tmp
         }
     }

     seek $data_name 0

     for {set k 0} {$k<($numatoms)} {incr k} {
         set max_tmp [gets $data_name]
     
         if { $max_tmp > $max } {
            set max $max_tmp
         }
     }

     set min -1.0
     set max  1.0

     seek $data_name 0

     axes location LowerLeft

     mol modcolor 0 top User
     mol colupdate 0 top 1
     mol scaleminmax top 0 $min $max
 #    mol modstyle 0 0 CPK 0.5 0.0 10 0
     mol modstyle 0 0 VDW 0.2 25.0

     animate goto 0

     for {set i 0} {$i<$numframes} {incr i} {

         for {set j 0} {$j<($numatoms)} {incr j} {
             set field [gets $data_name]
             set atomsel [atomselect top "index $j" frame $i]
             $atomsel set user $field
             $atomsel delete
         }
     }
}


set num 1
foreach args $argv {
   switch $args {
     -h {
        display_usage $PROG_NAME $argv
     }
     -v {
        display_version $PROG_NAME $VERSION
     }
     -f {
          
        if { $argc < 2 } {
           puts "Not enough arguments in command line."
           puts ""
           exit
      }

        set data [lindex $argv 1]
        draw_field $data


        set show [lindex $argv 3]
        if { $show == 0 } {
           render TachyonInternal output.ppm
        }

     }
   }

  incr num
}

if { $show == 0 } {
  exit
}
