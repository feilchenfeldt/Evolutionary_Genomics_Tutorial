# Unix tutorial – how to use the Terminal
Hannes Svardal

Acknowledgments:
This material is based on the Unix primer by Angelica Cuevas, Angela P. Fuentes-Pardo, Julia M.I. Barth
for the Population and Speciation Genomics Course in Cesky Krumlov 2022

<!-- 
##### Table of Contents  
[Headers](#headers)  
[Emphasis](#emphasis)  
-->

## Introductory slides

Some introductory slides can be found here: [add link]

## Learning goals

- Navigate in a UNIX terminal environment
- Create, move, and delete directories
- Create, move, delete and edit files
- Use basic UNIX commands and know where to find help

## How to use this tutorial

- Open a unix terminal
  - On Windows
    - install Ubuntu on the Windows subsystem for Linux (WSL)
      - [Press here for help](HowToInstallWSL.md)
    - Press `Windows Key`, type *Ubuntu* and press `Enter`
  - On Linux:
    - Open a Terminal
  - MacOS:
    - Open the app *Terminal* or install and open the app *iTerm*
    - Make sure that your shell is set to *bash*
- Questions or tasks are indicated with **Q**
- Text `with gray background` usually indicates a command that you can type or copy to the terminal


  <details>
    <summary>If you get stuck, check the answer-box.</summary>

  On no, only if you get stuck!! First try to find the answer yourself!

  </details>



## Why would we use the Terminal / shell in the first place?

*Scripting:* We can write down a sequence of commands to perform particular tasks or analyses;
when working with genomic data, a task usually takes minutes, sometimes hours or even days – it’s no fun to sit and wait in front of your computer this long just for a mouse-click to initiate the next task.

*Powerful Tools:* In UNIX, powerful tools are available that enable you to work through large amounts of files, data, and tasks quite quickly and in an automated (that is, programmatic) way.

*Easy remote access:* In most cases, it is not possible anymore to deal with genomic data on a desktop computer. You will usually run analyses on clusters at high performance computing facilities at your university, or – like in this course – on the Amazon cluster.

*GUI (Graphical User Interface) is not available* for many bioinformatics programs: Genomics is a fast evolving field and developing a GUI takes time and effort.

*Compatibility:* The terminal can (remotely) be accessed with computers running on different operating systems

## Basic syntax of shell commands

UNIX or shell commands have a basic structure of:
```
command -options target
```
The command comes first (such as `cd` or `ls` as we will see later) then any options
(always proceeded by a `–` or a `--` and sometimes followed by a value) 
and then the target (such as the file to move or the 
directory to list). 
These commands are written on the prompt (terminal command line).

The `-options` are sometimes called flags. 

The `targets` are sometimes called positional arguments.

Example:


    cp -r folder1 folder2

- Here `cp` is a bash command that copies files or folders.
- `-r` is an option that tells the program to copy recursively, meaning to include all files in the folder and in all subfolders.
- `folder1` and `folder2` are two targets. 
  - `folder1` is the file path from which `cp` copies files.
  - `folder2` is the file path to which `cp` copies files.

### Find your keys!

There are some keys that are used a lot in UNIX commands but can be difficult to find on some keyboards.

**Q** Open a text editor and type the following keys:

`~` tilde

`/` forward slash

`\` back slash or escape

`|` vertical bar or pipe

`#` hash or number or gate sign

`$` dollar sign

`*` asterisk

`’` single quote

`"` double quote

`  backtick

`ctrl c` The panic button: If you are running a process or 
program and it is stuck or doing something you don’t want it to
do: then hold the control key and press c. 
This will kill the current process and return you to your prompt.
If this does not work, close the terminal and open it again.

### Getting help

A UNIX cheat sheet like [this one here](https://files.fosswire.com/2007/08/fwunixref.pdf) might be helpful 
as a reference of some of the most common UNIX commands. <br>

Also, never forget that the internet is your best friend! Google your questions or use an AI chatbot. <br>

Most UNIX commands and many other programs have help pages accessed through: `command_name --help`, or `command_name -h`,
which describe in short notation different ways to run the program.
Some programs that need arguments a
Most programs also have a more exhaustive manual page accessed by typing `man PROGRAM_NAME`.

  Note that to exit man pages or many 
  other programs opening text in the terminal,
  you need to press `q`. 

**Q** Access the `ls` help page and the `ls` manual page.

  <details>
    <summary>Show me how to do this.</summary>
    

Type `ls --help` to access the “list” help page.
Type `man ls` to access the “list” manual page.

Note that if you type `ls -h` you don’t get the help page for ls. That’s because -h is the option that print sizes of files in a human-readable format (like 1K, 234M, 2G etc) when combined with the -l option, like in ls -lh. Find the -h option when you access the ls help page with ls --help
    
    
  </details>


**Q** What do the `cp`, `grep`, and `nano` commands do?

  <details>
    <summary>Show me how to get to the answer.</summary>
  Type, for example

  ```
  cp --help
  man cp
  ```
  The first one gives something like
  
  ```
  usage: cp [-R [-H | -L | -P]] [-fi | -n] [-aclpsvXx] source_file target_file
       cp [-R [-H | -L | -P]] [-fi | -n] [-aclpsvXx] source_file ... target_directory
  ```  
  Here, possible options are given with `-` and targets are described afterwards.
  Flags or targets that are placed in brackets `[]` are optional 
  (you can use them but you do not need to). 
  The pipe `|` symbol is an exlusive or, so it means that either one or
  the other option can be used.

  The above usage text still has limited information. We see all the
  flags but we do not know what they do. To get more information, 
  check `man cp` or google for example `cp unix usage` or 
  `cp unix examples` or `cp unix manual`. 

  </details>

### Navigation I

A computer file system is laid out as a hierarchical multifurcating tree structure. This may sound confusing but it is easy to think of it as boxes of boxes where each box is a directory.
There is one big box called the root. All other boxes are contained in this one big box. Boxes have labels such as ‘Users’ or ‘Applications’. Each box may contain more boxes (like Desktop or Downloads or Work) or files (like ‘file1.txt’ or ‘draft.docx’)
Thus it is hierarchical (boxes in boxes),
multifurcating
(each box can contain multiple boxes or files) 
tree structure (similar to how a tree has branches and leaves).

![Unix directory structure](Images/unix_directory_structure.png)

There are two ways to refer to directories and their positions in this hierarchy and relationship to other directories: absolute and relative paths.

A) **Absolute path**
The absolute path is the list of all directories starting from the root 
that lead to the current directory. Directories are separated using a `/`.

For example, the path to the directory ‘Desktop’ in the picture above is `/User/Desktop`

**Q** What is the absolute path to the directory `currentWork` above?

  <details>
    <summary>Show me the answer.</summary>
  
    /User/Desktop/currentWork

  </details>

B) **Relative path**

A directory can also be referred to by its relative location from some other directory 
(usually where you are working from). 
The parent directory of a directory is referred to using `..`
The current directory is referred to using `.`
For example, if I am in ‘Desktop’ and want to get to ‘User’ the relative path is `..`.
If I am in `User` and want to get to `Applications`, the relative path is 
`../Applications` (going one directory up, and then down into `Applications`).

**Q** What is the relative path to get from `Adobe` to `Microsoft`?

  <details>
    <summary>Show me the answer.</summary>
  
    ../Microsoft

  </details>

**Q** What is the relative path to get from `currentWork` to `Adobe`?

  <details>
    <summary>Show me the answer.</summary>
  
    ../../../Applications/Adobe

  </details>

### Download the tutorial data

If you have not done so yet,
**download the tutorial data in your terminal:**

- To return to your home folder, type


    cd ~

Note: Actually the tilde is not needed, because per default `cd` 
without argument goes to your home folder.

- Download the test data.


    wget  https://raw.githubusercontent.com/feilchenfeldt/Evolutionary_Genomics_Tutorial/main/Data.zip

- Then press `Enter`. A `.zip` archive (=compressed file) with test data should be downloaded.
  - Decompress the `.zip` archive

  
    unzip Data.zip



### Where am I?
Sometimes one can get confused in which folder the terminal currently is. 
The command `pwd` is very useful for this. It returns the current work directory.
- Type


    pwd

Confirm that you are in your home folder. If not, go there.

### Navigation II

Use the commands `ls` and `cd` to navigate the file system. 
Remember, `ls` shows you all files and folders in the current
directory and `cd <dirname>` changes to dirname. 

Note on syntax: When I write `<name>`, the `<>` just means that you
should replace the content by any appropriate name. You should
**not** actually type the symbols `<` and `>`.

**Q** Navigate to the folder `UnixBasics` which is located in 
the folder `Data` that you generated in your homefolder
by unzipping `Data.zip`.

  <details>
    <summary>Show me how to do this.</summary>
  
Assuming that you are in your home directory

      cd Data/UnixBasics

If you are not in your home directory, 
first go there by typing `cd`. If you still get an error, 
use `ls` to check whether the folder `Data` exists.

  </details>

**Q** Check whether you really are in the directory `UnixBasics`

  <details>
    <summary>Show me how to do this.</summary>

Type `pwd` to display the absolute path of the current directory.
    It should give something like `/home/<username>/Data/UnixBasics`

  </details>

**Q** List all files and folders in the current directory.

  <details>
    <summary>Show me how to do this.</summary>

      ls

  </details>

**Q** Check the size of all files in the current 

  <details>
    <summary>Show me how to do this.</summary>

`ls -l` The flag `-l` specifies a ‘long listing format’. 
It returns the columns: permissions, number of hardlinks, 
file owner, file group, file size in bytes, modification date, filename.

  However, you will see that the file size is not in a very useful format.
It is in number of bytes. Therefore, use `ls -lh`, which will print 
file-size in human-readable format e.g., kB or MB.
  </details>


**Q** Go back to your home directory.

  <details>
    <summary>Show me how to do this.</summary>
  
  Using the absolute path:
  
    cd /home/<your_username>
  (replace <your_username> by your username) 

  Using the relative path:
    
    cd ../../

  Using a really useful shortcut:
  
    cd

  </details>

**Q** Go to the folder `UnixBasics` in two steps,
by first going into the folder `Data` and then into 
the folder `UnixBasics`.

  <details>
    <summary>Show me how to do this.</summary>

    cd Data
then

    cd UnixBasics


  </details>

### Managing your directories and files




## Conda

In bioinformatics you will often need computer programs that are 
not part of your Unix default installation. There are several ways
of installing such programs. For some of them you need administrator
rights on your system.

Here we will only explain one way of installing programs packages, 
using the **conda** package manager.

The conda package manager has several advantages:
 - It works with large program respositories where you can find 
virtually all packages for *python*, many for R., and many unix programs 
especially bioinformatics programs.
 - Conda is cross-platform, so you can get similar software installations
on different operating systems.
 - You do not need any administrator rights to install packages with conda.
 - Unix (and python/R) tools usually depend on many other tools and programs. 
Conda makes sure that you have the right versions of all dependencies installed.
 - You can create separate conda environments with different versions 
of different packages.
 - You can export information on your conda environment so that
other people can redo the same analysis with the same software 
versions (Same "compute environment").

One disadvantage of conda is that it can be slow to resolve dependencies and 
install programs. This can be solved by creating new environments, 
by carefully choosing channels (places for where programs will be installed) and 
by using `mamba` instead of conda. (Not shown here)

### Installing conda

- Download conda

```
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh
```

(Note: For this tutorial we are using conda with python 3.8, 
but you might choose more up-to-date versions for your other projects.)

- Install miniconda

```
bash Miniconda3-py38_23.11.0-2-Linux-x86_64.sh -b
```

Once miniconda is installed, you need to initialise conda by running

    ~/miniconda3/bin/conda init


Now, every time you open a new terminal window, 
you should see `(base)` at the lefthand side of your command line.
This means that conda is activated.


