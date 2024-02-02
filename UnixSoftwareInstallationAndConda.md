### Installing conda

- Download conda


**Linux users** run
```
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh
```
**MacOS users** run
```
curl -O https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh
```


Note: For this tutorial we are using conda with python 3.8, 
but you might choose more up-to-date versions for your other projects.

- Install miniconda

```
bash Miniconda3-py38_23.11.0-2-Linux-x86_64.sh -b
```

Once miniconda is installed, you need to initialise conda by running

    ~/miniconda3/bin/conda init


Now, every time you open a new terminal window, 
you should see `(base)` at the lefthand side of your command line.
This means that conda is activated.

### Install packages with conda

The general syntax for installing programs with conda is `conda install <program_name>`.

If you want to install a given program, say `bcftools`, I would first check under which
name and in which channel this program is available by performing a websearch of
'conda install bcftools'.

This will show you that the right way to install `bcftools` is

        conda install bioconda::bcftools

In this, 'bioconda' is a channel. You can think of it as a package repository.