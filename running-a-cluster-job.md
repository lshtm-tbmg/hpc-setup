[<== Back to main README](README.md)

# Running a cluster job

**Please read through the whole document before attempting the example**

**Consider reading <https://cirrus.readthedocs.io/en/main/user-guide/batch.html#running-jobs-on-cirrus>**. It is very good.

I have split this up into two sections:

- [Running a cluster job](#running-a-cluster-job)
  - [1 Setting up and submitting a job](#1-setting-up-and-submitting-a-job)
    - [1.1 Set up](#11-set-up)
    - [1.2 Run R and bootstrap the environment](#12-run-r-and-bootstrap-the-environment)
    - [1.3 Submit job](#13-submit-job)
    - [1.4 A specific example job](#14-a-specific-example-job)
  - [2 Creating/Modifying a cluster job script](#2-creatingmodifying-a-cluster-job-script)
    - [2.1 Cluster directives](#21-cluster-directives)
    - [2.2 The Rscript call](#22-the-rscript-call)

* **Before you do any of this please make sure your `hpc-setup` folder is up to date:**

```bash
# If this is the first time you are updating the hpc-setup folder, then run:
cd "$HOME"/hpc-setup
git pull
# Log out and log in again

# If you have (ever) updated the hpc-setup folder before then run:
update-hpc-setup
# Log out and log in again
```

## 1 Setting up and submitting a job

### 1.1 Set up

* I suggest that you make a _new folder_ for each separate cluster job (unit of work) that you do.
* I suggest you use the same name for this folder as the cluster _job name_ (see later).
* You should make this in your **`/work/ec232/ec232/YourUserName`** folder.
* Clone the `tbvax` GitHub repository _into_ that new folder. Your folder layout might look like this:

```
/work/ec232/ec232/YourUserName/
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

- The cluster job submission scripts are stored in: `tbvax/cluster_scripts/cirrus`
  - **NOTE** There are two possible workflows here:
    - Approach 1: for each cluster job run, you can write a cluster job script on your own computer and commit it to git, push to GitHub, then clone back down to Cirrus. The cluster job script is then ready to submit.
    - Approach 2: for each cluster job run, you can make the folder for the cluster job, then write/modify the script _on_ cirrus itself.
    - I prefer approach 1 because it keeps a record of the cluster job scripts as well, but it is at the cost of more commits to git. However, git commits (especially small ones like this) are very cheap.

### 1.2 Run R and bootstrap the environment

- Before you submit the job, you have to make sure the R environment is configured correctly.
- Enter the `tbvax` folder that you cloned inside `FolderForClusterJob`
- Run the following in the terminal:

```bash
# Make sure you update hpc-setup (see above)
cd /work/ec232/ec232/YourUserName/FolderForClusterJob/tbvax # Enter the correct folder
git checkout Intro # Make sure you are on the Intro branch (during testing and this walkthrough)
module load 'R/4.1.2'
module load 'cmake/3.22.1'
HOME=/work/ec232/ec232/YourUserName R
```

* R should launch and `renv` should begin to bootstrap. It should offer to install packages, etc. Use `renv::restore()` to set up, say yes to installation and finish bootstrapping.
* You should do this for every cluster job before you actually submit it to the cluster.

> The very first time you do this it will take some time as `renv` must download and install all packages. The process should be faster for subsequent cluster jobs (as long as you are correctly located on /work).

### 1.3 Submit job

* Submitting a job is simply running the `sbatch` command with the path to the job script.
* Assuming the folder structure above, and a cluster job script called `demoscript.sh`.

```bash
cd /work/ec232/ec232/YourUserName/FolderForClusterJob # Ensure you are in the right place
sbatch tbvax/cluster_scripts/cirrus/demoscript.sh # Submit the job
```

You can then check the status of the job using `squeue --user=$USER` or the equivalent custom shortcut `usqueue`.

### 1.4 A specific example job

Here is the summary of commands to run the example job which we will call 'lshtm-test-job'.

NB: this will run an actual output generation script of tbvax-India.

```bash
# Make sure you update hpc-setup (see above)
cd /work/ec232/ec232/YourUserName # Enter /work
mkdir lshtm-test-job # Make a folder for your job
cd lshtm-test-job # Enter that folder
git clone git@github.com:lshtm-tbmg/tbvax.git # Clone tbvax
git checkout Intro # Checkout the "Intro" branch
module load 'R/4.1.2'
module load 'cmake/3.22.1'
HOME=/work/ec232/ec232/YourUserName R

### Complete the renv steps, then exit R and return to the prompt

sbatch tbvax/cluster_scripts/cirrus/IND_epicomplex.sh
```

## 2 Creating/Modifying a cluster job script

Please read the [**Running the model**][run-model] section on the tbvax wiki first.

This section deals with the **cluster submission script** (aka **cluster job script**) on Cirrus.

The example above uses `YourJobFolder/tbvax/cluster_scripts/cirrus/IND_epicomplex.sh`.

Here, we will describe the lines that (under typical circumstances) you should review and change for your particular job.

> Unless you know what you are doing, if it isn't mentioned here, then don't change it! Some of the commands are infrastructure!

Comments _other than_ `#SBATCH` _directives_ begin with the hash (`#`) and are ignored when the file is parsed.

### 2.1 Cluster directives

```bash
#SBATCH --job-name=job_name #!!CHANGE!!#
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1 
#SBATCH --tasks-per-node=36 
#SBATCH --array=0-71 
#SBATCH -t 3-0:0  #(amount of time requested: in days-hours:minutes:seconds, or just minutes)
#SBATCH --account=ec232
#SBATCH --qos=standard
```

This script requests a job called `job_name` (inventive, I know) for 1 node, with 36 cores for 3 days, for a job with 72 separate tasks in an array.

The directives (`#SBATCH`) control various aspects of the cluster job. Consider changing:

- `--job_name` : this should be the job name you decide. I suggest the same name as the folder you made, alphanumeric characters only, lower case, no spaces and no symbols.
- `--nodes` : essentially how many compute nodes (i.e., full multicore CPUs) you require. Each node has two CPUs each with 18 cores (=36 cores per node). You probably don't need to include this.
- `--tasks-per-node` : how many of the cores on the node will you use? Normally we use all, so 36. You probably don't need to include this.
- `--array` : if you are submitting a large parallel job with say, 1000 tasks, then you need to set `--array=0-999` (indexing begins at 0).
- `-t` : the maximum time you think the _overall_ job needs. The maximum time allowed is **4 days**.
- `qos` : quality of service. In principle you can change the relative priority of your jobs. See <https://cirrus.readthedocs.io/en/main/user-guide/batch.html#quality-of-service-qos>

> Unlike Harvard, EPCC has only one useful CPU partition ("standard"), so the `--partition` option should not be changed (unless we decide to use GPUs, in which case, `¯\_(ツ)_/¯`)

### 2.2 The Rscript call

This is where the magic happens.

This is the actual line where you point your _cluster job script_ to some kind of _R file_ and pass it some _arguments_.

* In this case, we are running `GenEpiOutput_complex.R`, which will iterate through fitted parameter sets, run the model and produce epidemiologic output (i.e., baseline and vaccine scenarios).
* Refer to [**Run Model**][run-model] for more details, but in brief:
  * `-c` - the ISO3 country code. "IND" for India.
  * `-s` - the scenarios file, which lists what scenarios to run (e.g., baseline vs vaccine) and the names of their corresponding XML files.
  * `-p` - parameters file - a CSV where each parameter set is a row.

```bash
# Run Rscript; redirect stdout and stderr to CO file
Rscript GenEpiOutput_complex.R -c "IND" -s "epi_vx_scenarios_noEndTB.csv" -p "IND_params.csv" >& "${CON}" || log "RScript Failed"
```

[run-model]: https://github.com/lshtm-tbmg/tbvax/wiki/Running-a-single-country-model#running-the-model
