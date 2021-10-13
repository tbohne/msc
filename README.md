# Master's Thesis at Osnabrueck University / DFKI

**Execution Monitoring for Long-Term Autonomous Plant Observation with a Mobile Robot**

![](thesis/pics/work_program.png)

Plan to interleave the reading / thinking / programming / experimenting and the writing.

## Dependencies for Baseline Simulation

- [arox_docker](https://git.ni.dfki.de/arox/arox_docker): dockerization of the AROX system
    - branch: `noetic`
    - compatible branches within docker container:
        - [arox_navigation_flex](https://git.ni.dfki.de/arox/arox_core/arox_navigation_flex): `low_yaw_goal_tolerance`
        - [arox_launch](https://git.ni.dfki.de/arox/arox_core/arox_launch): `feature_msc_setup_tim`
        - [arox_indoor_navi](https://git.ni.dfki.de/arox/arox_core/arox_indoor_navi): `feature_less_self_scan`
        - [arox_engine](https://git.ni.dfki.de/arox/arox_core/arox_engine): `feature_arox_battery`
        - [arox_planning](https://git.ni.dfki.de/arox/arox_core/arox_planning): `feature_lta_plan`
        - [arox_performance_parameters ](https://git.ni.dfki.de/arox/arox_core/arox_performance_parameters): `feature_performace_parameters`
- [arox_description](https://git.ni.dfki.de/arox/arox_core/arox_description): ROS launch files and URDF model for the AROX system
    - branch: `feature_msc_setup_tim`
- [container_description](https://git.ni.dfki.de/arox/container_description): ROS launch files and URDF model for the mobile container (charge station)
    - branch: `feature_simple_collisions`
- [innok_heros_description](https://git.ni.dfki.de/arox/innok_heros/innok_heros_description): URDF description for Innok Heros robot
    - branch: `arox_noetic`
- [innok_heros_driver](https://git.ni.dfki.de/arox/innok_heros/innok_heros_driver): ROS driver for the Innok Heros robot platform
    - branch: `master`
- [velodyne_simulator](https://bitbucket.org/DataspeedInc/velodyne_simulator/src/master/): URDF and gazebo plugin to provide simulated data from Velodyne laser scanners
    - branch: `master`
- [gazebo_langsenkamp](https://git.ni.dfki.de/zla/gazebo_langsenkamp): Langsenkamp world (test field)
    - branch: `feature_msc_setup_tim`

## Usage

- run simulation (with GUI): `roslaunch arox_description launch_arox_sim.launch gui:=true`
- spawn container: `roslaunch container_description spawn.launch`
- spawn AROX: `roslaunch arox_description spawn.launch`
- run AROX controllers: `roslaunch arox_description run_controllers.launch`
- run docker container named 'arox_msc': `aroxstartdocker arox_msc` (alias)
    - launch outdoor simulation: `roslaunch arox_launch arox_sim_outdoor.launch`

## Plan Executor (within docker container)

- access exploration GUI: `http://localhost/exploration_gui/`
- run AROX engine: `rosrun arox_engine arox_engine.py`
- run AROX planner: `rosrun arox_planning arox_planner.py`

## Control AROX

- launch keyboard control: `rosrun teleop_twist_keyboard teleop_twist_keyboard.py`

## Visualize Sensor Data

- [rViz](https://wiki.ros.org/rviz)
    - fixed frame: `map`
    - add sensors by topic, e.g. `/velodyne_point` to visualize the point cloud recorded by the Velodyne 3D-Lidar sensor
    - or open the provided config `msc_conf.rviz`

## Open Container

- `rostopic pub -1 /container/rampA_position_controller/command std_msgs/Float64 "data: 2.0"`
