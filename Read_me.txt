This is Matlab GUI program that controls the Kuka Youbot robot. It uses rosmatlab toolbox provided by MathWorks.

--------------------- QUICK START GUIDE ----------------------------------------
In order to use this program, you will have to take the following steps.

A. On Kuka Youbot robot:

   1. Upgrade to ROS Hydro distribution (http://wiki.ros.org/hydro).
   2. Install Youbot driver and Ros Youbot support (install packages ros-hydro-youbotdriver and ros-hydro-youbot-driver-ros-interface)
   3. Start roscore
   4. Start youbot driver (use command: roslaunch youbot_driver_ros_interface youbot_driver.launch)
   
   
B. On a PC with matlab:

   1. Install rosmatlab from MathWorks (http://www.mathworks.com/hardware-support/robot-operating-system.html).
   2. Add support for brics_actuator messages (http://www.mathworks.com/matlabcentral/answers/125148-how-to-subscribe-publish-to-custom-messages-using-rosmatlab).
   3. start the youbot_control program.
   

-------------------------------------------------------------------------

   
   