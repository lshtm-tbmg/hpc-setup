[<== Back to main README](README.md)

# Running an example cluster job

I have split this up into two sections:

1. [Setting up and submitting a job](#1-setting-up-and-submitting-a-job) (using a ready made job script)
2. Creating a new job script

## 1. Setting up and submitting a job

### 1.1 Set up

* I suggest that you make a _new folder_ for each separate cluster job (unit of work) that you do.
* I suggest you use the same name for this folder as the cluster _job name_ (see later).
* You should make this in your `**/work/ec232/ec232/YourUserName**` folder.
* Clone the `tbvax` GitHub repository _into_ that new folder. Your folder layout might look like this:

```
YourHome/
└── FolderForClusterJob/                <-- Make this for each cluster job
    └── tbvax/                          <-- clone the tbvax repository
            ├── cluster_scripts/
            │   └── cirrus/             <-- store cirrus cluster scripts here
            │       ├── Script1
            │       ├── Script2
            │       └── Script100
            └── Various_other/
```

* This will ensure that each cluster job, output, and the model associated with it remain isolated from others to facilitate reproducibility and debugging.

* The cluster job submission scripts are stored in: `tbvax/cluster_scripts/cirrus`
  * **NOTE** There are two possible workflows here:
    * Approach 1: for each cluster job run, you can write a cluster job script on your own computer and commit it to git, push to GitHub, then clone back down to Cirrus. The cluster job script is then ready to submit.
    * Approach 2: for each cluster job run, you can make the folder for the cluster job, then write/modify the script _on_ cirrus itself.
    * I prefer approach 1 because it keeps a record of the cluster job scripts as well, but it is at the cost of more commits to git. However, git commits (especially small ones like this) are very cheap.

### 1.2 Run R and bootstrap the environment

* Before you submit the job, you have to make sure the R environment is configured correctly.
* Enter the `tbvax` folder that you cloned inside `FolderForClusterJob`
* Run the following in the terminal:

```bash
cd /work/ec232/ec232/YourUserName/FolderForClusterJob/tbvax # Enter the correct folder
git checkout Intro # Make sure you are on the Intro branch (during testing and this walkthrough)
module load 'R/4.0.2'
HOME=/work/ec232/ec232/YourUserName R
```

* R should launch and `renv` should begin to bootstrap. It should offer to install packages, etc. Use `renv::restore()` to set up, say yes to installation and finish bootstrapping.
* You should do this for every cluster job before you actually submit it to the cluster.

> The very first time you do this it will take some time as `renv` must download and install all packages. Subsequent cluster jobs (as long as you are correctly located on /work) should be faster.

### 1.3 Submit job

* Submitting a job is simply running the `sbatch` command with the associated cluster job script name.
* Assuming the folder structure above, and a cluster job script called `demo_script.sh`.

```bash
cd /work/ec232/ec232/YourUserName/FolderForClusterJob # Ensure you are in the right place
sbatch tbvax/cluster_scripts/demoscript.sh # Submit the job
```

You can then check the status of the job using `squeue --user=$USER` or the equivalent custom shortcut `usqueue`.

### 1.3 Example job

Here is the summary of commands to run the example job which we will call 'lshtm-test-job'.

NB: this will run an actual output generation script of tbvax-India.

```bash
cd /work/ec232/ec232/YourUserName # Enter /work
mkdir lshtm-test-job # Make a folder for your job
cd lshtm-test-job # Enter that folder
git clone git@github.com:lshtm-tbmg/tbvax.git # Clone tbvax
git checkout Intro # Checkout the "Intro" branch
module load 'R/4.0.2'
HOME=/work/ec232/ec232/YourUserName R

### Complete the renv steps, then exit R and return to the prompt

sbatch tbvax/cluster_scripts/cirrus/IND_epicomplex.sh
```
