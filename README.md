# Getting up and running on Cirrus

This repository contains files to ease getting up and running on the Edinburgh (Cirrus cluster).

The documentation for this cluster is good. If you get stuck, please read it:

**Please read the README (what you are currently reading) completely before trying to get up and running**

## 1 Overview

To get going you need to do the following:

1. Activate your SAFE account (you should have received an email)
2. Create a local SSH key pair (on your own computer) and add the public key to SAFE. NB: this will also add the public key to Cirrus.
3. Clone this repository (`hpc-setup`) and install the files (see [Cirrus instructions][])
4. Set up GitHub access using the GitHub CLI
5. Clone the `tbvax` repository
6. Enter the cloned repository and run `R` to get the `R` package environment set up.

Once you have completed item 1, log into Cirrus using _both_ your SSH key _and_ password at `login.cirrus.ac.uk`.

## 2 Cirrus instructions

The files in this repository (`.bashrc` and `.bash_profile`) are startup files. When you log into Cirrus for the _first time after installing them_, they will:

* Enable automatic module loading for future logins
* Download, install, and set as default the `micro` editor
* Download and install the [GitHub CLI][ghcli]

> **Modules:** Cirrus uses the same module system as LSHTM/Harvard. I have configured it to automatically load `R/4.0.2`, `tmux/3.3a` and `cmake/3.22`[^cmake].

### 2.1 Installing `.bashrc` and `.bash_profile`

**It is important to run the following code in the terminal exactly.**

The `hpc-setup` repository is public, so can be accessed on GitHub without credentials. NB: you must use **https**:

```bash
cd '$HOME'
rm $HOME/.bashrc
rm $HOME/.bash_profile
git clone https://github.com/lshtm-tbmg/hpc-setup.git
cd 'hpc-setup'
cp .bashrc $HOME/.bashrc
cp .bash_profile $HOME/.bash_profile
```

**Now log out of and back into Cirrus**. You should see some startup as it installs `micro` and the GitHub CLI.

### 2.2 Configuring access to GitHub

**Start by checking if you have already created an SSH key pair _on Cirrus_**:

```bash
ls -lah $HOME/.ssh
```

If you have a matched pair of files, one of which has a `.pub` extension, you have a keypair. Go to the GitHub CLI section.

If not, create a keypair:

```bash
ssh-keygen
```

* Mostly just press 'enter'. I would use the default name for the SSH key.
* Leave the passphrase blank.

#### 2.2.1 GitHub CLI

The [GitHub CLI][ghcli] makes it a bit easier to authenticate with GitHub, rather than manually creating SSH key pairs and copying things over.

I have created a screencast of using the GitHub CLI. Please watch:

**NOTE:** It will likely fail to open a browser window for you. Simply go to <https://github.com/login/device> and enter the 8 digit code there. Once you have done that, _return to the terminal_ and **press enter** to complete the process.

[![asciicast](https://asciinema.org/a/eyYUm2w7VNEbEirGETIUmN4eP.svg)](https://asciinema.org/a/eyYUm2w7VNEbEirGETIUmN4eP)

## 3 Getting started with `tbvax`

First, clone the `tbvax` repository and checkout the **Intro** branch. Note we're not back to using SSH (`git@github.com:`):

```bash
cd '$HOME'
git clone git@github.com:lshtm-tbmg/tbvax.git
cd tbvax
git checkout Intro
```

Open R. `renv` will bootstrap. Then run `renv::restore()` to install the R package environment.

## 4 Other notes

* Although the `R` and `cmake` modules load automatically when you log in, I would recommend putting the relevant `module load` commands at the top of any cluster job submission scripts.


[^cmake]: I think `arrow` requires `cmake v3.22` to compile.

[ghcli]: cli.github.com
