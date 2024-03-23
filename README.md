# Senior Project: ARCTIC

## Project Description
Welcome to the README file for our automated penetration testing program developed for the Army's Multi-Domain Task Force (MDTF) cyber range. The MDTF has tasked us with creating an innovative solution that enhances their cybersecurity defense training capabilities in a controlled environment. The primary objective of our project is to develop an automated penetration testing program that provides soldiers with realistic cybersecurity defense training. This involves simulating user activities, creating controlled noise, and replicating real-world cyber scenarios within various Microsoft Windows systems on their network
## Project Overview
1. **Establish a "Pseudo-Users" System:**
   - Develop a system that autonomously generates user activities, including simulating actions like creating files, sending emails, and executing random events.
   - Integrate the pseudo-users system into different Microsoft Windows systems within the MDTF network.

2. **Automate Red Team Actions:**
   - Implement automation for red team actions based on established repositories of known attacks.
   - Simulate red team activities to challenge and enhance soldiers' defensive skills.

3. **Enhance Realism and Complexity:**
   - Create a training environment that closely mirrors real-world cyber scenarios.
   - Provide soldiers with challenging and diverse training experiences to improve their readiness for cyber threats.
## Key Features
- **Pseudo-Users Management:**
  - Create, manage, and maintain pseudo-users within the MDTF network.
  - Simulate a wide range of user activities to create a realistic training environment.

- **Red Team Automation:**
  - Automate red team actions based on established repositories of known attacks.
  - Challenge soldiers with simulated cyber threats to enhance their defensive capabilities.

- **Flexibility and Customization:**
  - Provide flexibility to simulate various cyber attack scenarios.
  - Allow customization of training exercises based on specific objectives and skill levels.
## Technologies Used
- OpenStack
- powershell
- python
- Rocky9
## Installation and Usage

1. **Prerequisites:**
   

2. **Clone the Repository:**
   - The Windows image will have our agent script along with a "scripts" folder that will be placed in Documents
  
# Senior Project: ARCTIC User Guide
## Quick Overview
Our architecture consists of three different types of deployed agents a Logging/Manager agent,
a Normal user agent, and a Bad user agent. These agents can either be set up manually by
pulling and running the scripts from the repo or by deploying the images of the 3 agents.
You only need to deploy one management agent but you can deploy any number of normal or
bad users depending on your needs. These good and bad users will all send logs of the last ran
action to the single manager over port 5000. Then the manager will analyze the user’s health
and display the results to the GUI Green means executed a script within 20 minutes, yellow
means has not received a log file in over 20 minutes but has received one within an hour, and
red means not received a log from the agent in over an hour. When these images are deployed
the scripts are automatically started with the task schedular and will continue to run until the
task is turned off.
##Basic Setup
##Deployment with setup Images
Pre-Image steps:
1. Download the iso for the good user and bad user and script manager
2. Create a VM for the manager and get the manager agents IP address
3. Create at least 1 bad and good agent and set the IP address to that of your logs that will
be sent to the manager in the first couple lines of the sender script
4. Create a new Iso Image with the new set IP address of your manager then deploy
agents to VMs
5. Boot them and enjoy.
##Notes for scripts to run manually
-The logging management agent will need to have a set inbound firewall rule for traffic over a
set High static port in our case port 5000
-Deployed agents will need to have an outbound rule allowing traffic over the set high static port
- Execution policy will need to be set to allow scripts to be automatically executed as well as
administrator privileges
##Manual Steps:
1. Download the code from the repository.
2. Make sure you have more than one Windows VM setup in VirtualBox or any virtual
environment (You will need 1 for the manager and at least 1 more for a user if you want
more than one user you will need more VM’s)
3. Move the code in each of the VM’s
4. Then for the manager, you will need to run Listen, Anylize, and GUI Scripts.
5. GUI runs in Python so will need to be downloaded to run the display
6. On the Normal agent will need to run the Agent and Sender Script
7. Now in the user Vm’s you will need to go to C:\Users\{Username}\Documents and put
the safe scripts folder with all the scripts
8. On the Bad agent will need to run Mal_agent and Sender Script
9. Now in the user Vm’s you will need to go to C:\Users\{Username}\Documents and put
the safe scripts folder and the MalwareBundle folder with all the scripts
10. Note in both agent's sender scripts the IP of the manager will need to be changed to the
IP of your manager
11. You can then Schedule the scripts with Windows Task Scheduler to run on start-up so
the agent will just need to be started and will start simulating network activity and
sending logs to the manage
